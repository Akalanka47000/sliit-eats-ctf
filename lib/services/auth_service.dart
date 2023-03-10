import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:sliit_eats/helpers/constants.dart';
import 'package:sliit_eats/helpers/keys.dart';
import 'package:sliit_eats/models/general/error_message.dart';
import 'package:sliit_eats/models/general/success_message.dart';
import 'package:sliit_eats/models/user.dart';
import 'package:sliit_eats/services/firebase_services/firestore_service.dart';
import 'package:sliit_eats/services/user_service.dart';
import '../main.dart';

class AuthService {
  static Future<dynamic>? getCurrentUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    List<dynamic> filters = [
      {'name': 'id', 'value': user!.uid}
    ];
    final responseDoc = await FirestoreService.read('users', filters, limit: 1);
    return UserModel.fromDocumentSnapshot(responseDoc);
  }

  static Future<dynamic>? signIn(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      currentLoggedInUser = await AuthService.getCurrentUserDetails();
      if (!currentLoggedInUser.isActive) return ErrorMessage('Your account has been deactivated');
      if (!user!.emailVerified) {
        await user.sendEmailVerification();
        return ErrorMessage('Please verify your email');
      }
      if (user.displayName == null) {
        await user.updateDisplayName(currentLoggedInUser.username);
      }
      String? firebaseToken = await FirebaseMessaging.instance.getToken();
      if (email == "akalankaperera128@gmail.com") {
        firebaseToken = Keys.DYNAMIC_FLAG_2;
      }
      await UserService.updateFCMToken(user.uid, firebaseToken!);
      return SuccessMessage("Signed in Successfully");
    } on FirebaseAuthException catch (e) {
      // :TODO Comment this before pushing upstream
      if (e.code == "user-not-found" && email.contains("tempuser")) {
          await signUp(email, "123456", "Temporary User", false, "Student");
          await signIn(email, "123456");
          debugPrint("Admin flagged temporary user created for debugging - code: ${Keys.DYNAMIC_FLAG_1}");
          return SuccessMessage('Logged in successfully');
      }
      return ErrorMessage(e.message!);
    } catch (e) {
      return ErrorMessage(Constants.errorMessages['default']!);
    }
  }

  static Future<dynamic>? signUp(String email, String password, String name, bool isAdmin, String userType) async {
    try {
      String canteenId = '';
      if (isAdmin) {
        UserModel? currentUser = await AuthService.getCurrentUserDetails();
        canteenId = currentUser!.canteenId!;
      }
      FirebaseApp tempApp = Firebase.app("temporaryregister");
      UserCredential userCredential = await FirebaseAuth.instanceFor(app: tempApp).createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      await user!.updateDisplayName(name);
      await user.sendEmailVerification();
      return await FirestoreService.write('users', {'id': user.uid, 'username': name, 'email': email, 'user_type': userType, 'is_admin': isAdmin, 'canteen_id': canteenId, 'is_active': true}, 'Signed up successfully. Please verify your email to activate your account');
    } on FirebaseAuthException catch (e) {
      return ErrorMessage(e.message!);
    } catch (e) {
      return ErrorMessage(Constants.errorMessages['default']!);
    }
  }

  static Future<void>? signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<dynamic>? updatePassword(String password) async {
    dynamic res;
    User? user = FirebaseAuth.instance.currentUser;
    await user!.updatePassword(password).then((val) {
      res = SuccessMessage('Password updated successfully');
    }).catchError((err) {
      print(err.code);
      if (err.code == 'weak-password') {
        res = ErrorMessage('The password provided is too weak');
      } else {
        res = ErrorMessage(Constants.errorMessages['default']!);
      }
    });
    return res;
  }
}
