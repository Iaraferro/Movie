# CineMovie

Projeto desenvolvido para a disciplina de Programação para Dispositivos Móveis I.

O aplicativo consiste em um diário de filmes e séries. O usuário pode buscar títulos utilizando a API do The Movie Database (TMDB) e, nas próximas etapas do projeto, poderá salvar suas avaliações, notas e comentários.

## Integrantes

- Di Matheus
- Kaylane
- Higor Valuar
- Iara Martins

## Tecnologias e Arquitetura

- Flutter: Interface e desenvolvimento mobile/web.
- Provider: Gerenciamento de estado.
- MVVM: O código está estruturado em `models`, `services`, `repositories`, `viewmodels` e `views`.
- TMDB API: Consumo de API REST para a busca de filmes em português.

## Como executar o projeto

1. Clone este repositório:
```bash
git clone https://github.com/Iaraferro/Movie.git
Crie um arquivo .env na raiz do projeto (no mesmo nível do pubspec.yaml) e adicione a sua chave de API do TMDB. Para obter uma chave, crie uma conta no site do TMDB:

env
TMDB_API_KEY=sua_chave_aqui
Instale as dependências:

bash
flutter pub get
Execute o aplicativo no navegador ou em um dispositivo móvel:

bash
flutter run -d chrome
Status do Projeto
☑ Estrutura base e MVVM
☑ Consumo da API do TMDB
☑ Telas de navegação e busca
□ Autenticação com Google (Supabase)
□ CRUD do diário de filmes (Supabase)