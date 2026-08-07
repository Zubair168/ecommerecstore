import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      String email, String password, String displayName) async {
    final cred = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await cred.user?.updateDisplayName(displayName);
    // Save profile to Firestore
    await _db.collection('users').doc(cred.user!.uid).set({
      'uid': cred.user!.uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': '',
      'createdAt': FieldValue.serverTimestamp(),
    });
    return cred;
  }

  /// Send password reset email
  static Future<void> resetPassword(String email) =>
      _auth.sendPasswordResetEmail(email: email);

  /// Sign out
  static Future<void> signOut() => _auth.signOut();

  /// Sign in with Google (Simulated for this demo, usually requires google_sign_in package)
  static Future<UserCredential?> signInWithGoogle() async {
    // In a real app with google_sign_in:
    // final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    // final OAuthCredential credential = GoogleAuthProvider.credential(
    //   accessToken: googleAuth.accessToken,
    //   idToken: googleAuth.idToken,
    // );
    // return await FirebaseAuth.instance.signInWithCredential(credential);

    // Mocking for the UI flow to work immediately:
    await Future.delayed(const Duration(seconds: 1));
    return null; // Return a dummy or handle in UI
  }

  /// Update user profile in Firestore
  static Future<void> updateProfile(Map<String, dynamic> data) async {
    final uid = currentUser?.uid;
    if (uid == null) return;
    await _db.collection('users').doc(uid).update(data);
  }
}
