import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/article.dart';
import '../models/user_profile.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  CollectionReference get _favoritesRef => _firestore.collection('favorites');

  Future<bool> isFavorite(int articleId) async {
    if (_uid == null) return false;
    final doc = await _favoritesRef.doc('${_uid}_$articleId').get();
    return doc.exists;
  }

  Future<void> addFavorite(Article article) async {
    if (_uid == null) return;
    await _favoritesRef.doc('${_uid}_${article.id}').set({
      'userId': _uid,
      'articleId': article.id,
      'title': article.title,
      'imageUrl': article.imageUrl,
      'newsSite': article.newsSite,
      'summary': article.summary,
      'url': article.url,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeFavorite(int articleId) async {
    if (_uid == null) return;
    await _favoritesRef.doc('${_uid}_$articleId').delete();
  }

  Stream<List<Map<String, dynamic>>> getFavoritesStream() {
    if (_uid == null) return const Stream.empty();
    return _favoritesRef
        .where('userId', isEqualTo: _uid)
        .snapshots()
        .map((snapshot) {
      final favorites = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      favorites.sort((a, b) {
        final aTime = a['createdAt'];
        final bTime = b['createdAt'];
        if (aTime is Timestamp && bTime is Timestamp) {
          return bTime.compareTo(aTime);
        }
        return 0;
      });

      return favorites;
    });
  }

  Future<UserProfile?> getUserProfile() async {
    if (_uid == null) return null;
    final doc = await _firestore.collection('users').doc(_uid).get();
    if (!doc.exists) return null;
    return UserProfile.fromMap(_uid!, doc.data()!);
  }

  Stream<UserProfile?> getUserProfileStream() {
    if (_uid == null) return const Stream.empty();
    return _firestore.collection('users').doc(_uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserProfile.fromMap(_uid!, doc.data()!);
    });
  }
}
