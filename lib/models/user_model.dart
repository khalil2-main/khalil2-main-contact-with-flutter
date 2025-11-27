class UserModel {
  final int? id;
  final String name;
  final String lastName;
  final String email;
  final String password;

  UserModel({
    this.id,
    required this.name,
    required this.lastName,
    required this.email,
    required this.password,
  });
  // refactor data that come from the data base
  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    name: json["name"],
    lastName: json["last_name"],
    email: json["email"],
    password: json["password"],
  );
  // convert object to a map so I can send it to the database
  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "last_name": lastName,
    "email": email,
    "password": password,
  };
}
