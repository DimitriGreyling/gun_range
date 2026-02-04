class BookingGuest {
  String? bookingId;
  String? id;
  String? name;
  String? email;
  String? phone;
  DateTime? createdAt;
  bool? isPrimary;

  BookingGuest({
    this.name,
    this.email,
    this.phone,
    this.createdAt,
    this.isPrimary,
    this.id,
    this.bookingId,
  });

  factory BookingGuest.fromJson(Map<String, dynamic> json) => BookingGuest(
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : null,
        isPrimary: json['is_primary'],
        id: json['id'],
        bookingId: json['booking_id'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
        'created_at': createdAt?.toIso8601String(),
        'is_primary': isPrimary,
        'id': id,
        'booking_id': bookingId,
      };
}
