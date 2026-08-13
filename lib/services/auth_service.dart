import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _db = FirebaseFirestore.instance;

  static User? get currentUser => _auth.currentUser;
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign in with email and password
  static Future<UserCredential> signIn(String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  /// Create account with email, password, and display name
  static Future<UserCredential> signUp(
    String email,
    String password,
    String displayName,
  ) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await cred.user?.updateDisplayName(displayName);
    // Save profile to Firestore
    await _db.collection('users').doc(cred.user!.uid).set({
      'uid': cred.user!.uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': '',
      'createdAt': FieldValue.serverTimestamp(),
    });
    // Send email verification when available
    try {
      await cred.user?.sendEmailVerification();
    } catch (_) {
      // ignore - verification is optional for demo
    }
    return cred;
  }

  /// Send password reset email
  static Future<void> resetPassword(String email) =>
      _auth.sendPasswordResetEmail(email: email);

  /// Sign out
  static Future<void> signOut() => _auth.signOut();

  /// Sign in with Google (Simulated for this demo, usually requires google_sign_in package)
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      // Web uses popup flow
      if (kIsWeb) {
        final provider = GoogleAuthProvider();
        final userCred = await _auth.signInWithPopup(provider);
        await _ensureUserDoc(userCred.user);
        return userCred;
      }

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null; // user cancelled

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCred = await _auth.signInWithCredential(credential);
      await _ensureUserDoc(userCred.user);
      return userCred;
    } on FirebaseAuthException {
      rethrow;
    } catch (_) {
      rethrow;
    }
  }

  static Future<void> _ensureUserDoc(User? user) async {
    if (user == null) return;
    final doc = _db.collection('users').doc(user.uid);
    final snapshot = await doc.get();
    if (!snapshot.exists) {
      await doc.set({
        'uid': user.uid,
        'email': user.email ?? '',
        'displayName': user.displayName ?? '',
        'photoUrl': user.photoURL ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } else {
      // Ensure basic fields are present
      await doc.set({
        'email': user.email ?? '',
        'displayName': user.displayName ?? '',
        'photoUrl': user.photoURL ?? '',
      }, SetOptions(merge: true));
    }
  }

  /// Update user profile in Firestore
  static Future<void> updateProfile(Map<String, dynamic> data) async {
    final uid = currentUser?.uid;
    if (uid == null) return;
    await _db.collection('users').doc(uid).update(data);
  }
}
