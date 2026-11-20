import 'package:flutter/foundation.dart';
import '../models/movie.dart';
import '../repositories/movie_repository.dart';
import 'view_status.dart';

class SearchViewModel extends ChangeNotifier {
  final MovieRepository _repository;

  SearchViewModel(this._repository);

  ViewStatus status = ViewStatus.inicial;
  List<Movie> filmes = [];
  String mensagemErro = '';

  Future<void> buscar(String texto) async {
    if (texto.trim().isEmpty) return;

    status = ViewStatus.carregando;
    notifyListeners();

    try {
      filmes = await _repository.buscarFilmes(texto.trim());
      status = filmes.isEmpty ? ViewStatus.vazio : ViewStatus.sucesso;
    } catch (e) {
      status = ViewStatus.erro;
      mensagemErro = e.toString();
    }

    notifyListeners();
  }
}