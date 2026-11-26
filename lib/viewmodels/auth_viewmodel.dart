import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/auth_service.dart';
import 'view_status.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _service;
  late final StreamSubscription<AuthState> _subscription;

  Session? _sessao;
  bool _carregando = false;
  bool _descartado = false;
  String _mensagemErro = '';

  AuthViewModel(this._service) {
    _sessao = _service.sessaoAtual;

    _subscription = _service.mudancas.listen(
      _aoAlterarAutenticacao,
      onError: (Object erro, StackTrace stackTrace) {
        _mensagemErro = 'Falha ao atualizar a sessão.';
        _notificar();
      },
    );
  }

  // Estado disponibilizado para as Views.
  Session? get sessaoAtual => _sessao;
  User? get usuarioAtual => _sessao?.user;
  bool get estaAutenticado => _sessao != null;
  bool get carregando => _carregando;
  String get mensagemErro => _mensagemErro;

  ViewStatus get status {
    if (_carregando) return ViewStatus.carregando;
    if (_mensagemErro.isNotEmpty) return ViewStatus.erro;
    if (estaAutenticado) return ViewStatus.sucesso;
    return ViewStatus.inicial;
  }

  // Atualiza o estado após login, logout ou renovação da sessão.
  void _aoAlterarAutenticacao(AuthState estado) {
    _sessao = estado.session;

    if (estado.event == AuthChangeEvent.signedIn ||
        estado.event == AuthChangeEvent.signedOut) {
      _mensagemErro = '';
    }

    _notificar();
  }

  Future<void> entrarComGoogle() async {
    if (_carregando || estaAutenticado) return;

    await _executar(
      _service.entrarComGoogle,
      'Não foi possível iniciar o login com Google.',
    );
  }

  Future<void> sair() async {
    if (_carregando || !estaAutenticado) return;

    await _executar(_service.sair, 'Não foi possível encerrar a sessão.');
  }

  void limparErro() {
    _mensagemErro = '';
    _notificar();
  }

  Future<void> _executar(
    Future<void> Function() acao,
    String mensagemFalha,
  ) async {
    _carregando = true;
    _mensagemErro = '';
    _notificar();

    try {
      await acao();
    } catch (_) {
      _mensagemErro = mensagemFalha;
    } finally {
      _carregando = false;
      _notificar();
    }
  }

  void _notificar() {
    if (!_descartado) notifyListeners();
  }

  @override
  void dispose() {
    _descartado = true;
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
