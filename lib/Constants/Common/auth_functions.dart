import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:twitter_login/twitter_login.dart';

class AuthFunctions {
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();
  LoginResult? _loginResult;
  String twitterToken = "";
  UserCredential? authResult;

  Future<UserCredential?> signInWithTwitter() async {
    String? newAuthToken;
    final twitterLogin = TwitterLogin(
        apiKey: "iGASTpEg6bGwBF7Ctf75Foc3W",
        apiSecretKey: "PrS6yDs26V65nrwUSPSsLk0WKuJnhMLw74FxmVEt4iShyUD8La",
        redirectURI: "com.tradewatch.tradewatch://");

    // Trigger the sign-in flow
    await twitterLogin.login().then((value) async {
      newAuthToken = value.authToken;
      if (newAuthToken != null) {
        final twitterAuthCredential = TwitterAuthProvider.credential(
          accessToken: value.authToken!,
          secret: value.authTokenSecret!,
        );
        twitterToken = value.authToken!;
        authResult = await auth.signInWithCredential(twitterAuthCredential);
        return authResult;
      } else {
        return authResult;
      }
    });
    return authResult;
  }

  Future<UserCredential?> signInWithFacebook() async {
    AccessToken? newAuthToken;
    final LoginResult loginResult = await FacebookAuth.instance.login(permissions: ["email", "public_profile"]);
    _loginResult = loginResult;
    newAuthToken = _loginResult!.accessToken;
    if (newAuthToken != null) {
      final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
      UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
      return authResult;
    } else {
      return authResult;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      authResult = await auth.signInWithCredential(credential);
      return authResult;
    } else {
      return authResult;
    }

    // Once signed in, return the UserCredential
  }

  /*Future<UserCredential?> signinApples() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    final oAuthProvider = OAuthProvider('apple.com');
    final appleCredential = oAuthProvider.credential(
      idToken: credential.identityToken,
      accessToken: credential.authorizationCode,
    );
    final authResult =
        await FirebaseAuth.instance.signInWithCredential(appleCredential);
    final firebaseUser = authResult.user;
    return authResult;
  }*/

  Future<UserCredential?> signInApples() async {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );
    final oAuthProvider = OAuthProvider('apple.com');
    final appleCredential = oAuthProvider.credential(
      idToken: credential.identityToken,
      rawNonce: rawNonce,
    );
    final authResult = await FirebaseAuth.instance.signInWithCredential(appleCredential);
    return authResult;
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<bool> signOutUser() async {
    await auth.signOut();
    await googleSignIn.disconnect();
    await FacebookAuth.instance.logOut();
    return Future.value(true);
  }
}
