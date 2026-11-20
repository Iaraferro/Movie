import 'package:flutter/foundation.dart';
import '../models/movie.dart';
import '../repositories/movie_repository.dart';

enum SearchStatus { inicial, carregando, sucesso, vazio, erro }

class SearchViewModel extends ChangeNotifier {
  final MovieRepository _repository;

  SearchViewModel(this._repository);

  SearchStatus status = SearchStatus.inicial;
  List<Movie> filmes = [];
  String mensagemErro = '';

  Future<void> buscar(String texto) async {
    if (texto.trim().isEmpty) return;

    status = SearchStatus.carregando;
    notifyListeners(); 

    try {
      filmes = await _repository.buscarFilmes(texto);
      
      if (filmes.isEmpty) {
        status = SearchStatus.vazio;
      } else {
        status = SearchStatus.sucesso;
      }
    } catch (e) {
      status = SearchStatus.erro;
      mensagemErro = e.toString();
    }
    
    notifyListeners(); 
  }
}