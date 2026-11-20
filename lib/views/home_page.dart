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
                // Aqui está a mágica para ficar responsivo:
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 180, 
                  childAspectRatio: 0.65, 
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                // Aqui estava faltando o itemCount:
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
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Hero(
                           tag: filme.id.toString(), // O ID garante que ele voe para o filme certo
                           child: Image.network(filme.posterUrl, fit: BoxFit.cover),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 70,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [Colors.black87, Colors.transparent],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            left: 8,
                            right: 8,
                            child: Text(
                              filme.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ), // Fecha o GridView
            ), // Fecha o Expanded
          ],
        ); // Fecha o Column e o return
    } // Fecha o switch
  } // Fecha o _buildCorpo
} // Fecha a classe