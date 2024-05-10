import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/providers/failure.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/providers/typedef.dart';
import '../screen/phone_screen.dart';

final authRepositoryProvider = Provider(
      (ref) => AuthRepository(ref.read(authProvider),
  ),
);

class AuthRepository {
  final FirebaseAuth _auth;
  AuthRepository(this._auth);


  FutureVoid phoneSignIn(
      String phoneNumber,
      ) async {
    try {
     return right( await _auth.verifyPhoneNumber(
       phoneNumber: phoneNumber,
       //  Automatic handling of the SMS code
       verificationCompleted: (PhoneAuthCredential credential) {
         // !!! works only on android !!!
         // await _auth.signInWithCredential(credential);
       },
       // Displays a message when verification fails
       verificationFailed: (FirebaseException e) {
         if (e.code == 'invalid-phone-number') {
           if (kDebugMode) {
             print('The provided phone number is not valid.');
           }
         }
       },
       // Displays a dialog box when OTP is sent
       codeSent: ((String verificationId, int? resendToken) async {
         PhoneScreen.verify=verificationId;
       }),
       codeAutoRetrievalTimeout: (String verificationId) {
         // Auto-resolution timed out...
       },
     )) ;

    } catch (e,s) {
      print(e);
      print(s);
     return left(Failure(e.toString()));
    }
  }

  FutureVoid verifyOtp(
      String code,
      ) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: PhoneScreen.verify,
          smsCode: code);
     return right(await _auth.signInWithCredential(credential)) ;
    } catch (e) {
      print(e);
     return left(Failure(e.toString()));
    }
  }

}