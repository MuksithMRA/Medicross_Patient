import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medicross_patient/Provider/error_provider.dart';
import '../Model/register_user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection("patients");

  Future<String?> signUpWithEmailAndPassword(RegisterUser registerUser) async {
    List<String> notifications = [];
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: registerUser.email.trim(),
        password: registerUser.password,
      );
      if (result.user?.uid != null) {
        await FirebaseAuth.instance.currentUser
            ?.updateDisplayName(registerUser.fullName);

        await _collectionReference.doc(result.user?.uid).set({
          "notifications": notifications,
          "fullName": registerUser.fullName,
          "email": registerUser.email.trim(),
          "city": registerUser.city,
          "phone": registerUser.phoneNumber,
          "uid": result.user?.uid,
          "type": "patient",
          "profilePic":
              "https://firebasestorage.googleapis.com/v0/b/doctor-app-52b40.appspot.com/o/avatar.png?alt=media&token=8ee31ea5-9b11-4384-8e9b-f0fcc4daf8a9"
        });
       
      }

      return result.user?.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ErrorProvider.message = "The password provided is too weak";
      } else if (e.code == 'email-already-in-use') {
        ErrorProvider.message = "The account already exists for that email";
      }
    } on FirebaseException catch (e) {
      ErrorProvider.message = e.code;
    } catch (e) {
      ErrorProvider.message = e.toString();
    }
    return null;
  }

  Future<String?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      return result.user?.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ErrorProvider.message = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        ErrorProvider.message = "Wrong password provided for that user";
      } else {
        ErrorProvider.message = "Something went wrong";
      }
      return null;
    } catch (e) {
      ErrorProvider.message = "$e";
      return null;
    }
  }

  Future<String?> signOut() async {
    await _auth.signOut();
    return _auth.currentUser?.uid;
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      final cred = EmailAuthProvider.credential(
          email: user?.email ?? "", password: currentPassword);
      await user?.reauthenticateWithCredential(cred);
      await user?.updatePassword(newPassword).then((value) {
        AuthService().signOut();
      });
    } on FirebaseException catch (e) {
      ErrorProvider.message = e.code;
    }
  }
}
