class Event {
  final String id;
  final String rangeId;
  final String title;
  final String description;
  final DateTime eventDate;
  final double price;
  final int capacity;

  Event({
    required this.id,
    required this.rangeId,
    required this.title,
    required this.description,
    required this.eventDate,
    required this.price,
    required this.capacity,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json['id'],
        rangeId: json['range_id'],
        title: json['title'],
        description: json['description'],
        eventDate: DateTime.parse(json['event_date']),
        price: (json['price'] as num).toDouble(),
        capacity: json['capacity'],
      );
}
