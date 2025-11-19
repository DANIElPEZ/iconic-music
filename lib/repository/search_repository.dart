import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SearchRepository{
  Future<List<Map<String, dynamic>>> search(String? query)async{
    try{
      final encodedQuery = Uri.encodeQueryComponent(query ?? "");
      final response = await http.get(
        Uri.parse('${dotenv.env['API_BASIC_URL']}$encodedQuery'),
        headers: {
          'Accept': 'application/json'
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final List<dynamic> results = json['data'];
        final List<Map<String, dynamic>> tracks = results.map((track) {
          return {
            "id": track["id"],
            "title": track["title"],
            "image": track["artwork"]?["480x480"],
            "file_url": track["stream"]?["url"],
          };
        }).toList();

        return tracks;
      }
    }catch(e){
      print('Error: $e');
    }
    return [];
  }
}