import 'package:cinemovie/views/erro_view.dart';
import 'package:cinemovie/views/poster_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/categoria_filme.dart';
import '../models/movie.dart';
import '../viewmodels/home_viewmodel.dart';
import '../viewmodels/view_status.dart';
import 'movie_details_page.dart';
import 'search_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Carrega os filmes assim que a tela abre
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().carregarFilmes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Meu Diário',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
      body: Column(
        children: [
          _buildCategorias(vm),
          Expanded(child: _buildCorpo(vm)),
        ],
      ),
    );
  }

  /// Chips de categoria (rolam para o lado se não couberem).
  Widget _buildCategorias(HomeViewModel vm) {
    return SizedBox(
      height: 56,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: CategoriaFilme.values.map((categoria) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(categoria.titulo),
              selected: vm.categoria == categoria,
              onSelected: (_) => vm.selecionarCategoria(categoria),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Um case para cada estado da tela.
  Widget _buildCorpo(HomeViewModel vm) {
    switch (vm.status) {
      case ViewStatus.inicial:
      case ViewStatus.carregando:
        return const Center(child: CircularProgressIndicator());
      case ViewStatus.vazio:
        return const Center(child: Text('Nenhum filme encontrado.'));
      case ViewStatus.erro:
        return ErroView(
          mensagem: vm.mensagemErro,
          onTentarNovamente: vm.carregarFilmes,
        );
      case ViewStatus.sucesso:
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          // Responsivo: a quantidade de colunas se ajusta à largura da tela.
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 180,
            childAspectRatio: 0.65,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: vm.filmes.length,
          itemBuilder: (context, index) => _buildCard(vm.filmes[index]),
        );
    }
  }

  Widget _buildCard(Movie filme) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MovieDetailsPage(movie: filme)),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // O ID garante que o pôster "voe" para o filme certo
            Hero(
              tag: filme.id.toString(),
              child: PosterImage(url: filme.posterUrl),
            ),
            // Degradê para o título ficar legível
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
            // Nota no canto
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 2),
                    Text(
                      filme.voteAverage.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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
  }
}