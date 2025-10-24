class UserModel {
  final String name;
  final String email;
  final String? token;
  final String? image;
  final String? visa;
  final String? address;

  UserModel({
    required this.name,
    required this.email,
    required this.token,
    required this.image,
    required this.visa,
    required this.address,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      token: json['token'],
      image: json['image'],
      visa: json['Visa'],
      address: json['address'],
    );
  }
}
