import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  signInWithGoogle() async {
    // begin interactive sign-in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    // obtain auth details from request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    // create a new credential for the user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // finally, let's sign in
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<String?> getUserDisplayName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.displayName;
    }
    return null;
  }

  Future<String> getUniqueUsername(String displayName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .get();
      if (snapshot.exists) {
        return snapshot.data()!['username'];
      } else {
        final username = await generateUniqueUsername(displayName);
        await storeUserDisplayName(displayName, username);
        return username;
      }
    }
    throw Exception('User is not signed in.');
  }

  Future<String> generateUniqueUsername(String displayName) async {
    final random = Random();
    final prefix = displayName.replaceAll(' ', '').toLowerCase();
    final suffix = random.nextInt(9999).toString().padLeft(4, '0');
    final username = '$prefix$suffix';
    final snapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('username', isEqualTo: username)
        .get();
    if (snapshot.docs.isEmpty) {
      return username;
    } else {
      return generateUniqueUsername(displayName); // Recursively generate a new username if it already exists
    }
  }

  Future<void> storeUserDisplayName(String displayName, String username) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRef = FirebaseFirestore.instance.collection('user').doc(user.uid);
      await userRef.set({
        'displayName': displayName,
        'username': username,
      });
    }
  }
}
