import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Responsável pela comunicação com o Supabase Auth.
class AuthService {
  final GoTrueClient _auth;

  AuthService({GoTrueClient? auth})
    : _auth = auth ?? Supabase.instance.client.auth;

  static const String _deepLinkAndroid = 'br.edu.cinemovie://login-callback/';

  /// Endereço de retorno da autenticação.
  static String get _redirectUrl => kIsWeb ? Uri.base.origin : _deepLinkAndroid;

  /// Sessão atual do usuário.
  Session? get sessaoAtual => _auth.currentSession;

  /// Usuário autenticado.
  User? get usuarioAtual => _auth.currentUser;

  /// Verifica se existe uma sessão ativa.
  bool get estaAutenticado => sessaoAtual != null;

  /// Notifica mudanças na autenticação.
  Stream<AuthState> get mudancas => _auth.onAuthStateChange;

  /// Inicia a autenticação com uma conta Google.
  Future<void> entrarComGoogle() async {
    final iniciado = await _auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: _redirectUrl,
      authScreenLaunchMode: kIsWeb
          ? LaunchMode.platformDefault
          : LaunchMode.externalApplication,
    );

    if (!iniciado) {
      throw AuthException(
        'Não foi possível iniciar a autenticação com o Google.',
      );
    }
  }

  /// Encerra a sessão do usuário.
  Future<void> sair() async {
    await _auth.signOut();
  }
}
