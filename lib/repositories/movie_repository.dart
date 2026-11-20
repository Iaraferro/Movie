import '../models/categoria_filme.dart';
import '../models/movie.dart';
import '../services/tmdb_service.dart';

/// Os ViewModels só conhecem o repository. Na próxima etapa, é aqui que
/// os dados do TMDB vão se juntar aos do Supabase (diário).
class MovieRepository {
  final TmdbService _service;

  MovieRepository(this._service);

  Future<List<Movie>> buscarFilmes(String query) {
    return _service.searchMovies(query);
  }

  Future<List<Movie>> buscarPorCategoria(CategoriaFilme categoria) {
    return _service.getMovies(categoria);
  }
}