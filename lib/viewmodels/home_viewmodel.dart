import 'package:flutter/foundation.dart';
import '../models/categoria_filme.dart';
import '../models/movie.dart';
import '../repositories/movie_repository.dart';
import 'view_status.dart';

class HomeViewModel extends ChangeNotifier {
  final MovieRepository _repository;

  HomeViewModel(this._repository);

  ViewStatus status = ViewStatus.inicial;
  CategoriaFilme categoria = CategoriaFilme.populares;
  List<Movie> filmes = [];
  String mensagemErro = '';

  Future<void> carregarFilmes() async {
    final solicitada = categoria;

    status = ViewStatus.carregando;
    notifyListeners();

    try {
      final resultado = await _repository.buscarPorCategoria(solicitada);

      // Se o usuário trocou de chip enquanto carregava, ignora esta resposta
      // (senão ela sobrescreveria a lista da categoria nova).
      if (solicitada != categoria) return;

      filmes = resultado;
      status = filmes.isEmpty ? ViewStatus.vazio : ViewStatus.sucesso;
    } catch (e) {
      if (solicitada != categoria) return;
      status = ViewStatus.erro;
      mensagemErro = e.toString();
    }

    notifyListeners();
  }

  void selecionarCategoria(CategoriaFilme nova) {
    if (nova == categoria) return;
    categoria = nova;
    carregarFilmes();
  }
}