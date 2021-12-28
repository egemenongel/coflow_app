import 'package:coflow_app/features/models/user_model.dart';
import 'package:coflow_app/features/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final instance = FirebaseAuth.instance;
  Stream<User?> get authStateChanges => instance.authStateChanges();
  UserModel? _userFromFirebase(User? user) {
    return user != null ? UserModel(uid: user.uid, email: user.email) : null;
  }

  Future<dynamic> signUp({String? email, String? password}) async {
    try {
      UserCredential credential = await instance.createUserWithEmailAndPassword(
          email: email!, password: password!);
      User? user = credential.user;
      await DatabaseService(uid: user!.uid).updateUserData(email);
      return _userFromFirebase(user);
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future<dynamic> logIn({String? email, String? password}) async {
    try {
      UserCredential credential = await instance.signInWithEmailAndPassword(
          email: email!, password: password!);
      User? user = credential.user;
      // return user;
      return _userFromFirebase(user);
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future loginAnonymously() async {
    try {
      await instance.signInAnonymously();
      await DatabaseService(uid: instance.currentUser!.uid)
          .updateUserData("guest");
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future logOut() async {
    try {
      await instance.signOut();
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }
}
