import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:cinemovie/services/auth_service.dart';
import 'package:cinemovie/viewmodels/auth_viewmodel.dart';
import 'package:cinemovie/viewmodels/view_status.dart';

class FakeAuthService implements AuthService {
  final controller = StreamController<AuthState>.broadcast(sync: true);

  bool falharLogin = false;
  int chamadasLogin = 0;

  @override
  Session? sessaoAtual;

  @override
  User? get usuarioAtual => sessaoAtual?.user;

  @override
  bool get estaAutenticado => sessaoAtual != null;

  @override
  Stream<AuthState> get mudancas => controller.stream;

  @override
  Future<void> entrarComGoogle() async {
    chamadasLogin++;

    if (falharLogin) {
      throw AuthException('Falha simulada');
    }
  }

  void simularLogin() {
    sessaoAtual = Session(
      accessToken: 'token-ficticio',
      tokenType: 'bearer',
      user: const User(
        id: 'usuario-teste',
        appMetadata: {},
        userMetadata: {},
        aud: 'authenticated',
        email: 'teste@example.com',
        createdAt: '2026-01-01T00:00:00Z',
      ),
    );

    controller.add(AuthState(AuthChangeEvent.signedIn, sessaoAtual));
  }

  @override
  Future<void> sair() async {
    sessaoAtual = null;

    controller.add(AuthState(AuthChangeEvent.signedOut, null));
  }
}

void main() {
  late FakeAuthService service;
  late AuthViewModel viewModel;

  setUp(() {
    service = FakeAuthService();
    viewModel = AuthViewModel(service);
  });

  tearDown(() async {
    viewModel.dispose();
    await service.controller.close();
  });

  test('Inicia sem autenticacao', () {
    expect(viewModel.estaAutenticado, isFalse);
    expect(viewModel.usuarioAtual, isNull);
    expect(viewModel.status, ViewStatus.inicial);
  });

  test('Iniciar OAuth nao autentica imediatamente', () async {
    await viewModel.entrarComGoogle();

    expect(service.chamadasLogin, 1);
    expect(viewModel.estaAutenticado, isFalse);
    expect(viewModel.carregando, isFalse);
  });

  test('Atualiza a sessao apos login', () {
    service.simularLogin();

    expect(viewModel.estaAutenticado, isTrue);
    expect(viewModel.usuarioAtual?.email, 'teste@example.com');
    expect(viewModel.status, ViewStatus.sucesso);
  });

  test('Realiza logout corretamente', () async {
    service.simularLogin();

    await viewModel.sair();

    expect(viewModel.estaAutenticado, isFalse);
    expect(viewModel.usuarioAtual, isNull);
    expect(viewModel.status, ViewStatus.inicial);
  });

  test('Trata erros de autenticacao', () async {
    service.falharLogin = true;

    await viewModel.entrarComGoogle();

    expect(viewModel.status, ViewStatus.erro);
    expect(viewModel.mensagemErro, isNotEmpty);
    expect(viewModel.carregando, isFalse);
  });

  test('Limpa mensagens de erro', () async {
    service.falharLogin = true;

    await viewModel.entrarComGoogle();
    viewModel.limparErro();

    expect(viewModel.mensagemErro, isEmpty);
    expect(viewModel.status, ViewStatus.inicial);
  });

  test('Impede novo login quando ja autenticado', () async {
    service.simularLogin();

    await viewModel.entrarComGoogle();

    expect(service.chamadasLogin, 0);
  });
}
