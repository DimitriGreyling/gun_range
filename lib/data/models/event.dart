class Event {
  String? id;
  String? rangeId;
  String? title;
  String? description;
  DateTime? eventDate;
  double? price;
  int? capacity;

  bool nspIsFavorite = false;

  Event({
    this.id,
    this.rangeId,
    this.title,
    this.description,
    this.eventDate,
    this.price,
    this.capacity,
    this.nspIsFavorite = false,
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
