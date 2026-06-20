import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class ApiService {
  static const String baseUrl =
      'https://api.spaceflightnewsapi.net/v4/articles/?limit=20';

  /// Mengambil daftar artikel berita dari Spaceflight News API
  Future<List<Article>> fetchArticles() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'] ?? [];
      return results.map((item) => Article.fromJson(item)).toList();
    } else {
      throw Exception('Gagal mengambil data berita (${response.statusCode})');
    }
  }

  /// Mengambil detail satu artikel berdasarkan ID (opsional, jika dibutuhkan)
  Future<Article?> fetchArticleById(int id) async {
    final response = await http
        .get(Uri.parse('https://api.spaceflightnewsapi.net/v4/articles/$id/'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Article.fromJson(data);
    }
    return null;
  }
}