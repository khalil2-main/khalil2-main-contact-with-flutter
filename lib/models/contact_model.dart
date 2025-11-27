class ContactModel {
  final int? id;
  final String name;
  final String phoneNumber;
  final Uint8List? image;
  final bool isFav;

  ContactModel({
    this.id,
    required this.name,
    required this.phoneNumber,
    this.image,
    this.isFav = false,
  });

  factory ContactModel.fromMap(Map<String, dynamic> json) => ContactModel(
    id: json["id"],
    name: json["name"],
    phoneNumber: json["phone_number"],
    image: json["image"],
    isFav: json["isFav"] == 1,
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "phone_number": phoneNumber,
    "image": image,
    "isFav": isFav ? 1 : 0,
  };
}
