import 'package:cinemovie/views/erro_view.dart';
import 'package:cinemovie/views/poster_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/search_viewmodel.dart';
import '../viewmodels/view_status.dart';
import 'movie_details_page.dart';


class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Valida o formulário e, se estiver ok, pede a busca ao ViewModel.
  void _buscar(SearchViewModel vm) {
    if (_formKey.currentState!.validate()) {
      vm.buscar(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SearchViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Buscar Filme')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _controller,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  labelText: 'Nome do filme',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => _buscar(vm),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Digite o nome de um filme para buscar';
                  }
                  if (value.trim().length < 2) {
                    return 'Digite pelo menos 2 letras';
                  }
                  return null;
                },
                onFieldSubmitted: (_) => _buscar(vm),
              ),
            ),
          ),
          Expanded(child: _buildResultado(vm)),
        ],
      ),
    );
  }

  Widget _buildResultado(SearchViewModel vm) {
    switch (vm.status) {
      case ViewStatus.inicial:
        return const Center(child: Text('Pesquise por um filme para começar.'));
      case ViewStatus.carregando:
        return const Center(child: CircularProgressIndicator());
      case ViewStatus.vazio:
        return const Center(child: Text('Nenhum filme encontrado.'));
      case ViewStatus.erro:
        return ErroView(
          mensagem: vm.mensagemErro,
          onTentarNovamente: () => vm.buscar(_controller.text),
        );
      case ViewStatus.sucesso:
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: vm.filmes.length,
          itemBuilder: (context, index) {
            final filme = vm.filmes[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(8),
                leading: SizedBox(
                  width: 60,
                  height: 90,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: PosterImage(url: filme.posterUrl),
                  ),
                ),
                title: Text(
                  filme.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      filme.voteAverage.toStringAsFixed(1),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 12),
                    Text(filme.year),
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MovieDetailsPage(movie: filme),
                    ),
                  );
                },
              ),
            );
          },
        );
    }
  }
}