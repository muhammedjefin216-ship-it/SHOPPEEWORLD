class ProfileModel {
  final String id;
  final String name;
  final String phone;
  final String email;

  const ProfileModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
  });

  factory ProfileModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProfileModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
    };
  }
}