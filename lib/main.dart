import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'services/tmdb_service.dart';
import 'repositories/movie_repository.dart';
import 'viewmodels/search_viewmodel.dart';
import 'views/login_page.dart';
import 'viewmodels/home_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Carrega a chave da API do arquivo .env
  await dotenv.load(fileName: ".env");

  // Inicializa as dependências na ordem correta (Service -> Repository -> ViewModel)
  final tmdbService = TmdbService();
  final movieRepository = MovieRepository(tmdbService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SearchViewModel(movieRepository),
        ),
         ChangeNotifierProvider(
          create: (_) => HomeViewModel(movieRepository),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineMovie',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5142A1),
          brightness: Brightness.dark, 
        ),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}