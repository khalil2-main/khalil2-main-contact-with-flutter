import 'dart:typed_data';
class ContactModel {
  final int? id;
  final int? userId;
  final String name;
  final String phoneNumber;
  final Uint8List? image;
  final bool isFav;

  ContactModel({
    this.id,
    this.userId,
    required this.name,
    required this.phoneNumber,
    this.image,
    this.isFav = false,
  });
  // refactor data that come from the data base
  factory ContactModel.fromMap(Map<String, dynamic> json) => ContactModel(
    id: json["id"],
    userId: json["user_id"],
    name: json["name"],
    phoneNumber: json["phone_number"],
    image: json["image"],
    isFav: json["isFav"] == 1,
  );
  // refactor  object to a map so I can send it to the database
  Map<String, dynamic> toMap() => {
    "id": id,
    "user_id": userId,
    "name": name,
    "phone_number": phoneNumber,
    "image": image,
    "isFav": isFav ? 1 : 0,
  };
}
