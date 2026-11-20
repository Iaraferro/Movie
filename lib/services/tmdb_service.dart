import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class TmdbService {
  final String _apiKey = dotenv.env['TMDB_API_KEY'] ?? '';
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.parse(
      '$_baseUrl/search/movie?api_key=$_apiKey&language=pt-BR&query=$query',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao buscar filmes. Verifique a conexão.');
    }
  }
}