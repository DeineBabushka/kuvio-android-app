import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String username;
  final String? profileImage;
  final String? bio;
  final String? favoriteKitchen;
  final String? favoriteDish;
  final bool isAdmin;

  AppUser({
    required this.id,
    required this.username,
    this.profileImage,
    this.bio,
    this.favoriteKitchen,
    this.favoriteDish,
    this.isAdmin = false,
  });

  factory AppUser.fromMap(String id, Map<String, dynamic> data) {
    return AppUser(
      id: id,
      username: data['username'],
      profileImage: data['profileImage'],
      bio: data['bio'],
      favoriteKitchen: data['kitchen'],
      favoriteDish: data['favdish'],
      isAdmin: data['isAdmin'] ?? false,
    );
  }

  factory AppUser.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser.fromMap(doc.id, data);
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'profileImage': profileImage,
      'bio': bio,
      'kitchen': favoriteKitchen,
      'favdish': favoriteDish,
      'isAdmin': isAdmin,
    };
  }
}
