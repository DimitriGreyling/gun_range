class LookupModel {
  String? id;
  String? listValue;
  String? lookupValue;
  String? lookupDescription;
  bool? isActive;
  DateTime? createdAt;
  DateTime? modifiedDate;

  LookupModel({
  this.id,
  this.listValue,
  this.lookupValue,
  this.lookupDescription,
  this.isActive,
  this.createdAt,
  this.modifiedDate,
  });

    factory LookupModel.fromJson(Map<String, dynamic> json) => LookupModel(
        id: json['id'],
        listValue: json['list_value'],
        lookupValue: json['lookup_value'],
        lookupDescription: json['lookup_description'],
        createdAt: DateTime.tryParse(json['created_at']),
        modifiedDate: DateTime.tryParse(json['modified_date']),
        isActive: bool.tryParse(json['is_active'].toString()),
      );
}