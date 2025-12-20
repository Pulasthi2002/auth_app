class UserModel {
  final int id;
  final String name;
  final String email;
  final String createdAt;
  final String? profilePicture;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    this.profilePicture,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      createdAt: json['created_at'] ?? '',
      profilePicture: json['profile_picture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'created_at': createdAt,
      'profile_picture': profilePicture,
    };
  }
}
