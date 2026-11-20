import 'package:flutter/foundation.dart';
import '../models/movie.dart';
import '../repositories/movie_repository.dart';
import 'search_viewmodel.dart'; // Para reutilizar o enum SearchStatus

class HomeViewModel extends ChangeNotifier {
  final MovieRepository _repository;

  HomeViewModel(this._repository);

  SearchStatus status = SearchStatus.inicial;
  List<Movie> filmesPopulares = [];
  String mensagemErro = '';

  Future<void> carregarFilmesPopulares() async {
    status = SearchStatus.carregando;
    notifyListeners();

    try {
      filmesPopulares = await _repository.buscarPopulares();
      status = filmesPopulares.isEmpty ? SearchStatus.vazio : SearchStatus.sucesso;
    } catch (e) {
      status = SearchStatus.erro;
      mensagemErro = e.toString();
    }
    notifyListeners();
  }
}