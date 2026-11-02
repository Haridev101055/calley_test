import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../core/api_config.dart';
import '../models/call_list.dart';
import '../models/list_details.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}

/// Thin REST client. The API expects a JSON body ({"email": ...}) even on
/// GET requests, so we use a raw [http.Request] instead of `http.get`.
class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;

  Future<dynamic> _get(Uri uri) async {
    try {
      final request = http.Request('GET', uri)
        ..headers['Content-Type'] = 'application/json'
        ..body = jsonEncode({'email': ApiConfig.email});

      final streamed = await _client.send(request).timeout(ApiConfig.timeout);
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException('Server error (${response.statusCode}). Please try again.');
      }
      return jsonDecode(response.body);
    } on SocketException {
      throw ApiException('No internet connection.');
    } on TimeoutException {
      throw ApiException('The request timed out.');
    } on FormatException {
      throw ApiException('Unexpected response from server.');
    }
  }

  Future<List<CallList>> fetchLists() async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/list')
        .replace(queryParameters: {'userId': ApiConfig.userId});
    final data = await _get(uri);

    // Docs show a single object; a real list endpoint returns an array.
    final items = data is List ? data : (data is Map ? [data] : const []);
    return items
        .whereType<Map>()
        .map((e) => CallList.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<ListDetails> fetchListDetails(String listId) async {
    final data = await _get(Uri.parse('${ApiConfig.baseUrl}/list/$listId'));
    if (data is! Map) throw ApiException('Unexpected response from server.');
    return ListDetails.fromJson(Map<String, dynamic>.from(data));
  }
}
