# Supabase Roles & Permissions with Flutter (MVVM + Riverpod)

This document describes a **production-ready architecture** for handling **guest access, authentication, and role-based permissions** using:

* **Supabase** (Auth + RLS)
* **Flutter**
* **Riverpod**
* **MVVM architecture**

Roles supported:

* `member`
* `admin`
* `super_admin`

---

## 1. Core Principles

1. **Supabase RLS is the source of truth** (Flutter never enforces security)
2. **Guests can view public content** without authentication
3. **Authenticated users unlock features**
4. **Roles control privileged access**
5. Flutter UI reacts to auth/role state only

---

## 2. Supabase Database Design

### 2.1 Profiles Table

```sql
create table public.profiles (
  id uuid references auth.users(id) on delete cascade primary key,
  role text not null check (role in ('member', 'admin', 'super_admin')),
  created_at timestamptz default now()
);
```

---

### 2.2 Auto-create Profile on Signup

```sql
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, role)
  values (new.id, 'member');
  return new;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_new_user();
```

---

### 2.3 Enable Row Level Security

```sql
alter table public.profiles enable row level security;
```

---

## 3. Role Helper Function

```sql
create or replace function public.has_role(required_role text)
returns boolean as $$
  select exists (
    select 1 from public.profiles
    where id = auth.uid()
      and (
        role = required_role
        or role = 'super_admin'
        or (required_role = 'member' and role = 'admin')
      )
  );
$$ language sql stable;
```

### Role Hierarchy

| Required Role | Allowed                    |
| ------------- | -------------------------- |
| member        | member, admin, super_admin |
| admin         | admin, super_admin         |
| super_admin   | super_admin                |

---

## 4. RLS Policies

### 4.1 Public Read Access (Guests)

```sql
create policy "Public read"
on public.events
for select
using (true);
```

---

### 4.2 Authenticated Access Only

```sql
create policy "Authenticated users only"
on public.bookings
for all
using (auth.uid() is not null);
```

---

### 4.3 Admin / Super Admin Management

```sql
create policy "Admins manage events"
on public.events
for all
using (public.has_role('admin'));
```

---

## 5. Flutter Architecture (MVVM + Riverpod)

```
lib/
├─ core/
│  ├─ supabase/
│  ├─ auth/
│  └─ routing/
├─ data/
│  └─ repositories/
├─ domain/
│  └─ models/
└─ presentation/
   ├─ viewmodels/
   └─ views/
```

---

## 6. Flutter – Auth State Handling

### 6.1 Supabase Client Provider

```dart
final supabaseProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});
```

---

### 6.2 Auth User Provider

```dart
final authUserProvider = StreamProvider<User?>((ref) {
  final supabase = ref.read(supabaseProvider);
  return supabase.auth.onAuthStateChange
      .map((event) => event.session?.user);
});
```

---

### 6.3 Is Authenticated Provider

```dart
final isAuthenticatedProvider = Provider<bool>((ref) {
  final auth = ref.watch(authUserProvider);
  return auth.valueOrNull != null;
});
```

---

## 7. Domain Model

```dart
class Profile {
  final String id;
  final String role;

  const Profile({required this.id, required this.role});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      role: json['role'],
    );
  }

  bool get isAdmin => role == 'admin' || role == 'super_admin';
  bool get isSuperAdmin => role == 'super_admin';
}
```

---

## 8. Repository Layer

```dart
abstract class ProfileRepository {
  Future<Profile> getMyProfile();
}

class SupabaseProfileRepository implements ProfileRepository {
  final SupabaseClient client;

  SupabaseProfileRepository(this.client);

  @override
  Future<Profile> getMyProfile() async {
    final user = client.auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    final response = await client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();

    return Profile.fromJson(response);
  }
}
```

---

## 9. Profile ViewModel (Conditional Fetching)

```dart
final profileViewModelProvider =
    AsyncNotifierProvider<ProfileViewModel, Profile?>(
  ProfileViewModel.new,
);

class ProfileViewModel extends AsyncNotifier<Profile?> {
  @override
  Future<Profile?> build() async {
    final user = ref.watch(authUserProvider).valueOrNull;
    if (user == null) return null;

    final repo = ref.read(profileRepositoryProvider);
    return repo.getMyProfile();
  }
}
```

---

## 10. UI Behavior

### 10.1 Guest Experience

* Can browse public content
* Cannot perform protected actions

### 10.2 Logged-in User Experience

* Role-aware UI
* Extra functionality unlocked

```dart
if (!isAuthenticated) {
  return PublicContent();
}

if (profile.isAdmin) {
  showAdminTools();
}
```

---

## 11. Navigation Guards

```dart
class AuthGuard extends ConsumerWidget {
  final Widget child;

  const AuthGuard({required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuth = ref.watch(isAuthenticatedProvider);
    return isAuth ? child : const Text('Login required');
  }
}
```

---

## 12. App State Flow

```
Guest
  ↓
Public Content
  ↓ login
Authenticated
  ↓ fetch profile
Role-aware UI
  ↓
RLS-enforced actions
```

---

## 13. Best Practices

* Never trust Flutter for security
* Always enforce permissions via R
