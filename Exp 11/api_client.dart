import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/wallpaper.dart';

class ApiClient {
  final String baseUrl = "https://picsum.photos/v2/list";

  Future<List<Wallpaper>> fetchWallpapers() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Wallpaper.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load wallpapers. Status: ${response.statusCode}');
    }
  }
}
