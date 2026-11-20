import 'package:flutter/material.dart';
import 'search_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meu Diário')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.search, size: 40),
                title: const Text('Buscar Filmes'),
                subtitle: const Text('Encontre um filme para adicionar ao seu diário'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SearchPage()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}