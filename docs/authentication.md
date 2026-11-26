
# CineMovie — Autenticação

## Bloco A — Autenticação e infraestrutura

### Tecnologias

- Flutter e Dart
- Supabase Auth
- Google OAuth 2.0
- Provider e ChangeNotifier
- Deep linking no Android

### Configuração do ambiente

Adicionar ao arquivo `.env`, na raiz do projeto:

```dotenv
TMDB_API_KEY=CHAVE_TMDB
SUPABASE_URL=URL_DO_PROJETO
SUPABASE_PUBLISHABLE_KEY=CHAVE_PUBLICAVEL
```

Utilizar as credenciais compartilhadas pelo grupo.

O arquivo `.env` não deve ser versionado.
Nunca utilizar a Secret Key, Service Role Key ou
o Client Secret do Google no aplicativo.

### Arquitetura

- `lib/services/auth_service.dart`: comunicação com
  o Supabase Auth.
- `lib/viewmodels/auth_viewmodel.dart`: gerenciamento
  de estado, sessão e tratamento de erros.
- `lib/main.dart`: inicialização do Supabase e registro
  do AuthViewModel no MultiProvider.
- `android/app/src/main/AndroidManifest.xml`:
  configuração do deep link e permissão de internet.

### Integração com o frontend

O AuthViewModel já está registrado globalmente no Provider.

Importações necessárias:

```dart
import 'package:provider/provider.dart';
import 'package:cinemovie/viewmodels/auth_viewmodel.dart';
```

Acessar o estado reativo:

```dart
final auth = context.watch<AuthViewModel>();
```

Iniciar login com Google:

```dart
await context.read<AuthViewModel>().entrarComGoogle();
```

Realizar logout:

```dart
await context.read<AuthViewModel>().sair();
```

Propriedades disponíveis:

| Propriedade | Descrição |
|---|---|
| estaAutenticado | Indica existência de sessão |
| usuarioAtual | Usuário autenticado |
| sessaoAtual | Sessão do Supabase |
| carregando | Operação em andamento |
| mensagemErro | Mensagem de erro |
| status | Estado da operação |

Dados do usuário:

```dart
auth.usuarioAtual?.id
auth.usuarioAtual?.email
auth.usuarioAtual?.userMetadata
```

O início do OAuth não representa um login concluído.
A interface deve observar `estaAutenticado` para
determinar quando o usuário está autenticado.

A navegação e a proteção das telas são responsabilidades
da camada View. Nenhuma View deve acessar diretamente
o Supabase.

### Redirecionamentos OAuth

Web:

http://localhost:3000

Android:

br.edu.cinemovie://login-callback/

Executar na Web:

```bash
flutter run -d chrome --web-port 3000
```

Ou utilizar outro navegador:

```bash
flutter run -d web-server --web-hostname localhost --web-port 3000
```

### Testes

Validações funcionais realizadas:

- Login com Google na Web e no Android.
- Redirecionamento OAuth.
- Recuperação dos dados do usuário.
- Persistência da sessão.
- Logout.
- Retorno ao Android por deep link.

Executar testes automatizados:

```bash
flutter test
```

Resultado: 8 testes aprovados, sendo 7 específicos
do AuthViewModel e 1 preexistente.

### Escopo

O Bloco A disponibiliza toda a lógica de autenticação.
A interface definitiva, navegação, diário, CRUD e
políticas RLS pertencem aos demais integrantes.

### Observações

A compilação Android foi validada com AGP 9.1.1.

Existem sete apontamentos informativos preexistentes
relacionados à descontinuação do import
package:flutter/material.dart.