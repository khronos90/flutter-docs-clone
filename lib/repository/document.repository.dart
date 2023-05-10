import 'dart:convert';

import 'package:docs_clone_flutter/constants.dart';
import 'package:docs_clone_flutter/models/document.model.dart';
import 'package:docs_clone_flutter/models/error.model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

final documentRepositoryProvider =
    Provider((ref) => DocumentRepository(client: Client()));

class DocumentRepository {
  final Client _client;
  DocumentRepository({required Client client}) : _client = client;

  Future<ErrorModel> createDocument(String token) async {
    ErrorModel error = ErrorModel(error: 'Some error happened', data: null);
    try {
      var res = await _client.post(Uri.parse('$host/api/v1/document/create'),
          body:
              jsonEncode({'createdAt': DateTime.now().millisecondsSinceEpoch}),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          });
      switch (res.statusCode) {
        case 201:
          error = ErrorModel(
              error: null,
              data: DocumentModel.fromMap(json.decode(res.body)['data']));
          break;
        default:
          error = ErrorModel(error: res.body, data: null);
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }

  Future<ErrorModel> getDocuments(String token) async {
    ErrorModel error = ErrorModel(error: 'Some error happened', data: null);
    try {
      var res = await _client.get(Uri.parse('$host/api/v1/document/'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          });
      switch (res.statusCode) {
        case 200:
          List<DocumentModel> documents = [];

          for (int i = 0; i < json.decode(res.body)['data'].length; i++) {
            documents
                .add(DocumentModel.fromMap(json.decode(res.body)['data'][i]));
          }
          error = ErrorModel(
            error: null,
            data: documents,
          );
          break;
        default:
          error = ErrorModel(error: res.body, data: null);
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }

  Future<ErrorModel> updateDocumentTitle(
      {required String token,
      required String id,
      required String title}) async {
    ErrorModel error = ErrorModel(error: 'An error occurred', data: null);
    try {
      var res = await _client.post(Uri.parse('$host/api/v1/document/title'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
          body: jsonEncode({'title': title, 'id': id}));
      switch (res.statusCode) {
        case 200:
          error = ErrorModel(
              error: null,
              data: DocumentModel.fromMap(json.decode(res.body).data));
          break;
        default:
          error = ErrorModel(error: res.body, data: null);
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }

  Future<ErrorModel> getDocumentById(String token, String id) async {
    ErrorModel error = ErrorModel(error: 'Some error happened', data: null);
    try {
      var res = await _client.get(Uri.parse('$host/api/v1/document/$id'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          });
      switch (res.statusCode) {
        case 200:
          error = ErrorModel(
            error: null,
            data: DocumentModel.fromMap(json.decode(res.body)['data']),
          );
          break;
        default:
          throw 'This document does not exist';
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }
}
