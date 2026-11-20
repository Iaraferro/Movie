import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/categoria_filme.dart';
import '../models/movie.dart';

/// Erro com mensagem já pronta para mostrar ao usuário.
class TmdbException implements Exception {
  final String mensagem;
  TmdbException(this.mensagem);

  @override
  String toString() => mensagem;
}

class TmdbService {
  final String _apiKey = dotenv.env['TMDB_API_KEY'] ?? '';
  static const String _host = 'api.themoviedb.org';

  /// Busca por nome.
  Future<List<Movie>> searchMovies(String query) {
    return _buscarLista('search/movie', {'query': query});
  }

  /// Lista por categoria (populares, em cartaz...).
  Future<List<Movie>> getMovies(CategoriaFilme categoria) {
    return _buscarLista(_caminhoDa(categoria), {'page': '1'});
  }

  /// Só o service conhece os endereços da API.
  String _caminhoDa(CategoriaFilme categoria) {
    switch (categoria) {
      case CategoriaFilme.populares:
        return 'movie/popular';
      case CategoriaFilme.melhoresNotas:
        return 'movie/top_rated';
      case CategoriaFilme.emCartaz:
        return 'movie/now_playing';
      case CategoriaFilme.emBreve:
        return 'movie/upcoming';
    }
  }

  /// Único lugar que chama a API: todos os métodos acima usam este.
  Future<List<Movie>> _buscarLista(
    String caminho,
    Map<String, String> parametros,
  ) async {
    // Uri.https já codifica o texto da busca (acentos, espaços, "&"...).
    final url = Uri.https(_host, '/3/$caminho', {
      'api_key': _apiKey,
      'language': 'pt-BR',
      ...parametros,
    });

    final http.Response response;
    try {
      response = await http.get(url);
    } catch (_) {
      throw TmdbException('Sem conexão com a internet.');
    }

    if (response.statusCode != 200) {
      throw TmdbException(
        'Falha ao carregar filmes (código ${response.statusCode}).',
      );
    }

    final data = jsonDecode(response.body);
    final List results = data['results'];
    return results.map((json) => Movie.fromJson(json)).toList();
  }
}