class UserModel {
  final int id;
  final String name;
  final String email;
  final String createdAt;
  final String? profilePicture;  // Add this field

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    this.profilePicture,  // Add this parameter
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      createdAt: json['created_at'] ?? '',
      profilePicture: json['profile_picture'],  // Add this line
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'created_at': createdAt,
      'profile_picture': profilePicture,  // Add this line
    };
  }
}
