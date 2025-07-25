import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GoogleUserData {
  final String username;
  final String email;
  final String bio;
  final String kitchen;
  final String favdish;
  final bool isAdmin;
  final List<dynamic> favorites;
  final DateTime createdAt;

  GoogleUserData({
    required this.username,
    required this.email,
    this.bio = '',
    this.kitchen = '',
    this.favdish = '',
    this.isAdmin = false,
    this.favorites = const [],
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'createdAt': Timestamp.fromDate(createdAt),
      'bio': bio,
      'kitchen': kitchen,
      'favdish': favdish,
      'isAdmin': isAdmin,
      'favorites': favorites,
      'disabled': false,
    };
  }

  factory GoogleUserData.fromFirebaseUser(User user) {
    final name = user.displayName;
    final mail = user.email;

    return GoogleUserData(
      username: name ?? 'Google Nutzer',
      email: mail ?? '',
    );
  }
}
