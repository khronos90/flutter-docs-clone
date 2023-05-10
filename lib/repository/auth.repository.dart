import 'dart:convert';

import 'package:docs_clone_flutter/constants.dart';
import 'package:docs_clone_flutter/models/error.model.dart';
import 'package:docs_clone_flutter/models/user.model.dart';
import 'package:docs_clone_flutter/repository/local_storage.repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    googleSignIn: GoogleSignIn(),
    client: Client(),
    localStorageRepository: LocalStorageRepository()));

final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final Client _client;
  final LocalStorageRepository _localStorageRepository;

  AuthRepository(
      {required GoogleSignIn googleSignIn,
      required Client client,
      required LocalStorageRepository localStorageRepository})
      : _googleSignIn = googleSignIn,
        _client = client,
        _localStorageRepository = localStorageRepository;

  Future<ErrorModel> signInWithGoogle() async {
    ErrorModel error = ErrorModel(error: 'Some Error ocurred', data: null);
    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        final userAccount = UserModel(
            email: user.email,
            name: user.displayName ?? '',
            profilePic: user.photoUrl ?? '',
            uid: '',
            token: '');

        var res = await _client.post(Uri.parse('$host/api/v1/auth/signup'),
            body: userAccount.toJson(),
            headers: {'Content-Type': 'application/json; charset=UTF-8'});

        switch (res.statusCode) {
          case 200:
          case 201:
            final newUser = userAccount.copyWith(
                uid: jsonDecode(res.body)['user']['_id'],
                token: jsonDecode(res.body)['token']);
            error = ErrorModel(error: null, data: newUser);
            _localStorageRepository.setToken(newUser.token);
            break;
          case 500:
          default:
            throw 'Some error happened :(';
        }
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }

  Future<ErrorModel> getUserData() async {
    ErrorModel error = ErrorModel(error: "Some error ocurred", data: null);
    try {
      String? token = await _localStorageRepository.getToken();
      if (token != null) {
        var res = await _client.get(Uri.parse('$host/api/v1/auth'), headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token
        });

        switch (res.statusCode) {
          case 200:
            final user = UserModel.fromJson(jsonEncode(
              jsonDecode(res.body)['user'],
            )).copyWith(token: token);
            error = ErrorModel(error: null, data: user);
            break;
          default:
            throw 'Some error happened :(';
        }
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }

  void signOut() async {
    await _googleSignIn.signOut();
    _localStorageRepository.setToken('');
  }
}
