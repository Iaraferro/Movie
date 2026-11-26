import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'services/tmdb_service.dart';
import 'repositories/movie_repository.dart';
import 'viewmodels/search_viewmodel.dart';
import 'views/login_page.dart';
import 'viewmodels/home_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Carrega as variáveis de ambiente
  await dotenv.load(fileName: '.env');

  // Inicializa o Supabase
  await Supabase.initialize(
    url: dotenv.get('SUPABASE_URL'),
    publishableKey: dotenv.get('SUPABASE_PUBLISHABLE_KEY'),
  );

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