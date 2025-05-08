import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:peer_connects/core/services/user_preferences_service.dart';
import 'package:peer_connects/features/auth/data/models/user_model.dart';

abstract class FirebaseAuthDatasource {
  Stream<UserModel> get authStateChanges;
  Future<void> signUp({required String email, required String password, required String name});
  Future<void> signInWithEmailAndPassword({required String email, required String password});
  Future<void> signInWithGoogle();
  Future<void> signOut();
  UserModel get currentUser;
  Future<void> resetPassword(String email);
}

class FirebaseAuthDatasourceImpl implements FirebaseAuthDatasource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;
  final UserPreferencesService _preferencesService;

  FirebaseAuthDatasourceImpl({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
    UserPreferencesService? preferencesService,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _preferencesService = preferencesService ?? UserPreferencesService();

  @override
  Stream<UserModel> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      if (firebaseUser != null) {
        final userModel = UserModel.fromFirebase(firebaseUser);
        // Save user to preferences when auth state changes
        _preferencesService.saveUser(userModel);
        _preferencesService.setLoggedIn(true);
        return userModel;
      } else {
        return UserModel(id: '', email: '', name: '', photoUrl: null);
      }
    });
  }

  @override
  UserModel get currentUser {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser != null) {
      return UserModel.fromFirebase(firebaseUser);
    } else {
      throw Exception('No authenticated user found');
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Failed to reset password');
    }
  }

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (userCredential.user != null) {
        final userModel = UserModel.fromFirebase(userCredential.user!);
        // Save user data to shared preferences
        await _preferencesService.saveUser(userModel);
        await _preferencesService.setLoggedIn(true);
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Failed to sign in');
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        throw Exception('Google sign in aborted');
      }
      
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      
      if (userCredential.user != null) {
        // Check if user exists in Firestore
        final userDoc = await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();
        
        if (!userDoc.exists) {
          // Create user document if it doesn't exist
          await _firestore.collection('users').doc(userCredential.user!.uid).set({
            'email': userCredential.user!.email,
            'name': userCredential.user!.displayName,
            'photoUrl': userCredential.user!.photoURL,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
        
        final userModel = UserModel.fromFirebase(userCredential.user!);
        // Save user data to shared preferences
        await _preferencesService.saveUser(userModel);
        await _preferencesService.setLoggedIn(true);
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Failed to sign in with Google');
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      // Clear user data from shared preferences
      await _preferencesService.clearUserData();
    } catch (e) {
      throw Exception('Failed to sign out');
    }
  }

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (userCredential.user != null) {
        // Update display name
        await userCredential.user!.updateDisplayName(name);
        
        // Create user document in Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': email,
          'name': name,
          'photoUrl': null,
          'createdAt': FieldValue.serverTimestamp(),
        });
        
        final userModel = UserModel(
          id: userCredential.user!.uid,
          email: email,
          name: name,
          photoUrl: null,
        );
        
        // Save user data to shared preferences
        await _preferencesService.saveUser(userModel);
        await _preferencesService.setLoggedIn(true);
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Failed to sign up');
    }
  }
}