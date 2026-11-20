import '../models/movie.dart';
import '../services/tmdb_service.dart';

class MovieRepository {
  final TmdbService _service;

  MovieRepository(this._service);

  Future<List<Movie>> buscarFilmes(String query) async {
    return await _service.searchMovies(query);
  }
}