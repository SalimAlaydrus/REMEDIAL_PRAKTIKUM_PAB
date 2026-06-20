import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  /// Register user baru + simpan profil ke Firestore + simpan session
  Future<UserCredential> register({
    required String nama,
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    final credential = await _auth.createUserWithEmailAndPassword(
      email: cleanEmail,
      password: password,
    );

    // Simpan data profil ke Firestore collection "users"
    await _firestore.collection('users').doc(credential.user!.uid).set({
      'nama': nama,
      'email': cleanEmail,
      'instagram': '',
      'photoUrl': '',
    });

    await _saveSession(true, credential.user!.uid);
    return credential;
  }

  /// Login dengan email & password
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    final credential = await _auth.signInWithEmailAndPassword(
      email: cleanEmail,
      password: password,
    );
    await _saveSession(true, credential.user!.uid);
    return credential;
  }

  /// Kirim email reset password
  Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  /// Logout: hapus session, sign out dari Firebase
  Future<void> logout() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// Simpan status login ke SharedPreferences (local storage)
  Future<void> _saveSession(bool isLoggedIn, String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
    await prefs.setString('uid', uid);
  }

  /// Cek status session saat Splash Screen
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool('isLoggedIn') ?? false;
    // Pastikan juga Firebase masih punya current user yang valid
    return loggedIn && _auth.currentUser != null;
  }

  String errorMessage(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          return 'Email ini sudah terdaftar di Firebase Authentication.';
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return 'Email atau password salah.';
        case 'weak-password':
          return 'Password minimal 6 karakter.';
        case 'invalid-email':
          return 'Format email tidak valid.';
        case 'network-request-failed':
          return 'Koneksi internet bermasalah.';
      }
      return error.message ?? 'Terjadi kesalahan Firebase Auth.';
    }

    if (error is FirebaseException) {
      return 'Firebase error: ${error.message ?? error.code}';
    }

    return error.toString();
  }
}
