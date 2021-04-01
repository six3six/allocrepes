import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:stream_transform/stream_transform.dart';

import 'models/models.dart';

/// Thrown if during the sign up process if a failure occurs.
class SignUpFailure implements Exception {}

/// Thrown during the login process if a failure occurs.
class LogInWithEmailAndPasswordFailure implements Exception {}

class LogInWithTokenFailure implements Exception {}

/// Thrown during the sign in with google process if a failure occurs.
class LogInWithNotESIEEEmail implements Exception {}

/// Thrown during the logout process if a failure occurs.
class LogOutFailure implements Exception {}

/// {@template authentication_repository}
/// Repository which manages user authentication.
/// {@endtemplate}
class AuthenticationRepository {
  /// {@macro authentication_repository}
  AuthenticationRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance
          ..settings = Settings(persistenceEnabled: false);

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.empty] if the user is not authenticated.
  Stream<Stream<User>> get user async* {
    final Stream<firebase_auth.User?> stream = _firebaseAuth.authStateChanges();

    await for (firebase_auth.User? firebaseUser in stream) {
      if (firebaseUser == null)
        yield Stream.value(User.empty);
      else {
        yield firebaseUser.toUserStream;
      }
    }
  }

  /// Creates a new user with the provided [email] and [password].
  ///
  /// Throws a [SignUpFailure] if an exception occurs.
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final firebase_auth.UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await addUserInDatabase(userCredential.user!.uid, name, email);
    } on Exception {
      throw SignUpFailure();
    }
  }

  Future<void> loginDebug() async {
    _firebaseAuth.signInWithCustomToken("guest");
  }

  Future<void> addUserInDatabase(
      String userUid, String name, String email) async {
    await _firestore.collection("users").doc(userUid).set({
      "name": name,
      "email": email,
    });
  }

  Future<bool> userExistInDatabase(String userUid) async {
    DocumentSnapshot doc =
        await _firestore.collection("users").doc(userUid).get();
    return doc.exists;
  }

  /// Signs in with the provided [email] and [password].
  ///
  /// Throws a [LogInWithEmailAndPasswordFailure] if an exception occurs.
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on Exception {
      throw LogInWithEmailAndPasswordFailure();
    }
  }

  Future<void> logInWithToken({
    required String token,
  }) async {
    try {
      await _firebaseAuth.signInWithCustomToken(token);
    } on Exception {
      throw LogInWithTokenFailure();
    }
  }

  /// Signs out the current user which will emit
  /// [User.empty] from the [user] Stream.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
      ]);
    } on Exception {
      throw LogOutFailure();
    }
  }

  Future<void> changePassword(String newPassword) async {
    await _firebaseAuth.currentUser!.updatePassword(newPassword);
  }

  Future<bool> getUserRole(String uid) async {
    bool admin = false;
    try {
      final DocumentSnapshot admins = await FirebaseFirestore.instance
          .collection("roles")
          .doc("admins")
          .get();
      admins.data()!.keys.contains(uid);
      admin = true;
    } on StateError {
      admin = false;
    }
    return admin;
  }

  Future<User> getUserFromUid(String uid) async {
    final DocumentSnapshot snapshot =
        await _firestore.collection("users").doc(uid).get();

    if (!snapshot.exists) return User.empty.copyWith(id: uid, name: uid);
    final data = snapshot.data()!;
    final name = data["name"] ?? uid;
    return User(
      email: (data["email"]) as String,
      id: uid,
      admin: await getUserRole(uid),
      name: name,
      surname: data["surname"] ?? "",
      classe: data["classe"] ?? "",
      point: data["point"] ?? 0,
      photo: null,
    );
  }

  Stream<Map<String, User>> getUsers() async* {
    final adminCollection = FirebaseFirestore.instance.collection("roles");
    final userCollection = FirebaseFirestore.instance.collection("users");

    Map<String, User> users = {};
    Map<String, bool> isAdmin = {};

    Stream<QuerySnapshot> mStream =
        userCollection.snapshots().merge(adminCollection.snapshots());
    await for (var snap in mStream) {
      if (snap.docs.first.reference.parent == userCollection) {
        users = {};
      }
      for (var doc in snap.docs) {
        if (doc.reference.parent == adminCollection) {
          if (doc.reference == adminCollection.doc("admins")) {
            isAdmin =
                doc.data()?.map((key, value) => MapEntry(key, true)) ?? {};
          }
        } else if (doc.reference.parent == userCollection) {
          users[doc.id] = User.fromDocument(doc);
        }
      }

      users = users.map((id, user) =>
          MapEntry(id, user.copyWith(admin: isAdmin.containsKey(id))));

      yield users;
    }
  }
}

extension on firebase_auth.User {
  Stream<User> get toUserStream async* {
    final adminCollection =
        FirebaseFirestore.instance.collection("roles").doc("admins");
    final userCollection =
        FirebaseFirestore.instance.collection("users").doc(uid);
    User user = User.empty.copyWith(
      id: uid,
    );
    Stream<DocumentSnapshot> mStream =
        userCollection.snapshots().merge(adminCollection.snapshots());

    await for (DocumentSnapshot snap in mStream) {
      if (snap.reference == adminCollection) {
        print("admin " + (snap.data()?.keys.contains(uid) ?? false).toString());
        user = user.copyWith(admin: snap.data()?.keys.contains(uid) ?? false);
      } else {
        String? email;
        String? name;

        try {
          email = snap["email"];
        } catch (e) {}

        try {
          name = snap["name"];
        } catch (e) {}

        user = user.copyWith(
          email: email,
          name: name,
          photo: photoURL,
        );
      }
      yield user;
    }
  }
}
