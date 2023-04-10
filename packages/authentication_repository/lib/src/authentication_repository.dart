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

  final usersCollection =
      FirebaseFirestore.instance.collection('users').withConverter<User>(
            fromFirestore: (snapshot, _) => User.fromDocument(snapshot),
            toFirestore: (user, _) => user.toDocument(),
          );

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.empty] if the user is not authenticated.
  Stream<Stream<User>> get user async* {
    final stream = _firebaseAuth.userChanges();

    await for (firebase_auth.User? firebaseUser in stream) {
      if (firebaseUser == null) {
        yield Stream.value(User.empty);
      } else {
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
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await addUserInDatabase(userCredential.user!.uid, name, email);
    } on Exception {
      throw SignUpFailure();
    }
  }

  Future<void> loginDebug() async {
    await _firebaseAuth.signInWithCustomToken('guest');
  }

  Future<void> addUserInDatabase(
    String userUid,
    String name,
    String email,
  ) async {
    await _firestore.collection('users').doc(userUid).set({
      'name': name,
      'email': email,
    });
  }

  Future<bool> userExistInDatabase(String userUid) async {
    var doc = await _firestore.collection('users').doc(userUid).get();

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

  Query<User> getUsersQuery({
    String? usernameSearch,
    SortUser sort = SortUser.Name,
  }) {
    Query<User> usersQuery = usersCollection;

    switch (sort) {
      case SortUser.Name:
        usersQuery = usersQuery.orderBy('name', descending: false);
        break;
      case SortUser.Point:
        usersQuery = usersQuery.orderBy('point', descending: true);
        break;
    }

    if (usernameSearch != null && sort == SortUser.Name) {
      usersQuery = usersQuery.where('name', isGreaterThanOrEqualTo: usernameSearch);
    }

    return usersQuery;
  }

  Future<User?> getUserFromID(String id) async {
    final doc = await usersCollection.doc(id).get();
    return doc.data();
  }

  void updateUser(User user) {
    usersCollection.doc(user.id).set(user);
  }

  void removeUser(String uid) {
    usersCollection.doc(uid).delete();
  }
}

enum SortUser {
  Name,
  Point,
}

extension on firebase_auth.User {
  Stream<User> get toUserStream async* {
    final adminCollection =
        FirebaseFirestore.instance.collection('roles').doc('admins');
    final userCollection =
        FirebaseFirestore.instance.collection('users').doc(uid);
    var user = User.empty.copyWith(
      id: uid,
    );
    var mStream = userCollection.snapshots().merge(adminCollection.snapshots());

    await for (DocumentSnapshot<Map<String, dynamic>> snap in mStream) {
      if (snap.reference == adminCollection) {
        print('admin ' + (snap.data()?.keys.contains(uid) ?? false).toString());
        user = user.copyWith(admin: snap.data()?.keys.contains(uid) ?? false);
      } else {
        String? email;
        String? name;
        String? surname;
        int? point;

        try {
          email = snap['email'];
        } catch (e) {}

        try {
          name = snap['name'];
        } catch (e) {}
        try {
          surname = snap['surname'];
        } catch (e) {}

        try {
          point = snap['point'];
        } catch (e) {}

        user = user.copyWith(
          email: email,
          name: name,
          surname: surname,
          photo: photoURL,
          point: point,
          student: name != null,
        );
      }
      yield user;
    }
  }
}
