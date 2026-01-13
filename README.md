# Gun Range Promotion & Events Platform

## Technical & Product Specification

---

## 1. Overview

### Purpose

A mobile platform that allows **gun ranges and shooting clubs** to promote their facilities, publish events, manage bookings, and engage with shooters, while allowing **users** to discover ranges, view events, and make reservations.

This document combines **product specification** and **technical design** to serve as a single source of truth for development and planning.

---

## 2. Goals & Non-Goals

### Goals

* Centralize gun range discovery and event promotion
* Enable range owners to self-manage content
* Provide shooters with reliable, up-to-date information
* Monetize via subscriptions and bookings

### Non-Goals

* Selling firearms, ammunition, or accessories
* Peer-to-peer weapon marketplace
* Weapon ownership management

---

## 3. Target Users

### 3.1 Shooter (B2C)

* Sport shooters
* Hobbyists
* Beginners

### 3.2 Range Owner (B2B)

* Gun range operators
* Shooting clubs
* Training academies

### 3.3 Admin

* Platform administrators
* Moderation and compliance

---

## 4. Core Features

### 4.1 Shooter Features

* Discover nearby ranges
* Search and filter ranges
* View range profiles
* View and RSVP to events
* Booking history
* Notifications and reminders

### 4.2 Range Owner Features

* Manage range profile
* Create and manage events
* View attendees
* Basic analytics
* Subscription management

### 4.3 Admin Features

* Approve or suspend ranges
* Feature content
* View platform metrics

---

## 5. Monetization Strategy

* Subscription plans for ranges
* Commission per booking
* Featured listings
* Sponsored events

---

## 6. Technical Architecture

### 6.1 Stack

* **Frontend:** Flutter
* **State Management:** Riverpod (MVVM)
* **Backend:** Supabase
* **Database:** PostgreSQL
* **Storage:** Supabase Storage
* **Auth:** Supabase Auth

---

## 7. Architecture Pattern

**MVVM + Repository Pattern**

```
UI (Views)
 ↓
ViewModels (Riverpod StateNotifiers)
 ↓
Repositories
 ↓
Supabase (Postgres, Auth, Storage)
```

---

## 8. Project Structure

```
lib/
│
├── core/
│   ├── config/
│   ├── constants/
│   ├── routing/
│   ├── theme/
│   └── utils/
│
├── data/
│   ├── models/
│   ├── repositories/
│   └── datasources/
│
├── domain/
│   ├── services/
│   ├── usecases/
│   ├── validators/
│   └── enums/
│
├── presentation/
│   ├── auth/
│   ├── home/
│   ├── ranges/
│   ├── events/
│   ├── bookings/
│   ├── owner/
│   └── profile/
│
├── viewmodels/
│   ├── auth_vm.dart
│   ├── range_vm.dart
│   ├── event_vm.dart
│   └── booking_vm.dart
│
├── providers/
│   ├── supabase_provider.dart
│   ├── repository_providers.dart
│   └── viewmodel_providers.dart
│
└── main.dart
```

---

## 9. State Management (Riverpod)

### Provider Types Used

* `Provider` – Dependency injection
* `StateNotifierProvider` – ViewModels
* `FutureProvider` – Read-only async data
* `StreamProvider` – Realtime updates

---

## 10. ViewModel Design

### ViewModel Responsibilities

* Hold UI state
* Perform business logic
* Communicate with repositories
* No UI or database logic

### State Principles

* Immutable state objects
* Explicit loading and error states

---

## 11. Data Layer

### Repository Responsibilities

* Fetch and persist data
* Map database responses to models
* No state or UI logic

---

## 12. Database Design (Supabase)

### 12.1 profiles

* id (UUID, PK)
* full_name
* role (shooter | range_owner | admin)
* created_at

### 12.2 ranges

* id (UUID, PK)
* owner_id (FK → profiles)
* name
* description
* latitude
* longitude
* facilities (JSON)
* is_active
* created_at

### 12.3 events

* id (UUID, PK)
* range_id (FK → ranges)
* title
* description
* event_date
* price
* capacity
* created_at

### 12.4 bookings

* id (UUID, PK)
* user_id (FK → profiles)
* event_id (FK → events)
* status
* payment_status
* created_at

---

## 13. Security & RLS

* Row Level Security enabled on all tables
* Range owners can only modify their own data
* Public read-only access to active ranges/events
* Admin-only actions via Edge Functions

---

## 14. Media Storage

* Buckets:

  * range-images
  * event-images
* Structured paths per entity

---

## 15. Notifications

### MVP

* In-app notifications
* Supabase Realtime

### Future

* Push notifications (FCM)
* Email reminders

---

## 16. Compliance & Safety

* No weapon sales
* Age verification (18+)
* Country-based availability flags
* Safety disclaimers
* App Store compliance-first wording

---

## 17. Testing Strategy

* Unit tests for ViewModels and Repositories
* Widget tests with provider overrides
* Manual QA for owner and booking flows

---

## 18. Roadmap

### Phase 1 – MVP

* Range listings
* Events
* RSVP

### Phase 2

* Payments
* Reviews
* Notifications

### Phase 3

* Subscriptions
* Featured listings
* Analytics

---

## 19. Future Enhancements

* Web admin panel
* Offline caching
* Multi-language support
* White-label range apps

---

## 20. Summary

This specification defines a **scalable, compliant, and monetizable** platform built using **Flutter, Riverpod, MVVM, and Supabase**. It is suitable for MVP delivery and long-term growth.
