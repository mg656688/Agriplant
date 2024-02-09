class UserModel {
  String id;
  String name;
  String email;
  String avatarUrl;
  List  achievements;
  String bio;
  List  plants;



  UserModel(
      {required this.id,
        required this.name,
        required this.email,
        required this.avatarUrl,
        required this.achievements,
        required this.bio,
        required this.plants,});

  factory UserModel.fromFirebaseUser(Map<String, dynamic> data) {
    return UserModel(
        id: data['id'],
        name: data['name'],
        email: data['email'] ?? '',
        avatarUrl: data['avatarUrl'] ?? '',
        achievements: data['achievements'] ?? [],
        bio: data['bio'] ?? '',
        plants:data['plants'] ?? []
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'avatarUrl': avatarUrl,
    'achievements':achievements,
    'bio': bio,
    'plants': plants,
  };
}