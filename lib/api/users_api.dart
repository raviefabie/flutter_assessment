import 'dart:convert';

import 'package:flutter_assessment_api/model/users.dart';
import 'package:http/http.dart' as http;

class SearchUserApi {
  static Future<List<Users>> getUsers(String query) async {
    final url = Uri.parse(
        'https://reqres.in/api/users?page=1');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List users = json.decode(response.body);

      return users.map((json) => Users.fromJson(json)).where((book) {
        final emailLower = book.email.toLowerCase();
        final fnameLower = book.firstName.toLowerCase();
        final lnameLower = book.lastName.toLowerCase();
        final searchLower = query.toLowerCase();

        return emailLower.contains(searchLower) ||
            fnameLower.contains(searchLower) ||
            lnameLower.contains(searchLower);
      }).toList();
    } else {
      throw Exception();
    }
  }
}