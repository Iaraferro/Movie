import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/home_viewmodel.dart';
import '../viewmodels/search_viewmodel.dart';
import 'search_page.dart';
import 'movie_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Carrega os filmes populares assim que a tela abre
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().carregarFilmesPopulares();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Diário', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchPage()),
              );
            },
          ),
        ],
      ),
      body: _buildCorpo(vm),
    );
  }

  Widget _buildCorpo(HomeViewModel vm) {
    switch (vm.status) {
      case SearchStatus.inicial:
      case SearchStatus.carregando:
        return const Center(child: CircularProgressIndicator());
      case SearchStatus.vazio:
        return const Center(child: Text('Nenhum filme popular encontrado.'));
      case SearchStatus.erro:
        return Center(child: Text('Erro: ${vm.mensagemErro}'));
      case SearchStatus.sucesso:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Populares da Semana',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 colunas
                  childAspectRatio: 0.6, // Proporção da capa do filme
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: vm.filmesPopulares.length,
                itemBuilder: (context, index) {
                  final filme = vm.filmesPopulares[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MovieDetailsPage(movie: filme),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        filme.posterUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
    }
  }
}