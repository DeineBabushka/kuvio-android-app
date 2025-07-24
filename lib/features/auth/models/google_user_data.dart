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
    final map = <String, dynamic>{};
    map['username'] = username;
    map['email'] = email;
    map['createdAt'] = Timestamp.fromDate(createdAt);
    map['bio'] = bio;
    map['kitchen'] = kitchen;
    map['favdish'] = favdish;
    map['isAdmin'] = isAdmin;
    map['favorites'] = favorites;
    return map;
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
