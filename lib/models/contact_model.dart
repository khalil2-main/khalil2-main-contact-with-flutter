import 'dart:typed_data';

class ContactModel {
  final int? id;
  final String name;
  final String phoneNumber;
  final Uint8List? image; // Profile image stored as bytes

  ContactModel({
    this.id,
    required this.name,
    required this.phoneNumber,
    this.image,
  });
  // refactor data that come from the data base
  factory ContactModel.fromMap(Map<String, dynamic> json) => ContactModel(
    id: json["id"],
    name: json["name"],
    phoneNumber: json["phone_number"],
    image: json["image"],
  );
  // convert object to a map so I can send it to the database
  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "phone_number": phoneNumber,
    "image": image,
  };
}
