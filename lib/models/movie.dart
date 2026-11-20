class Movie {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final double voteAverage;
  final String? releaseDate; // NOVO: data de lançamento (ex.: 2024-05-20)

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    required this.voteAverage,
    this.releaseDate,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    // O TMDB manda "" (texto vazio) quando não tem sinopse em português,
    // então só o "?? valor padrão" não resolve: precisamos checar o vazio.
    final sinopse = json['overview'] as String?;
    final data = json['release_date'] as String?;

    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Sem título',
      overview: (sinopse == null || sinopse.isEmpty)
          ? 'Sem descrição disponível.'
          : sinopse,
      posterPath: json['poster_path'],
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: (data == null || data.length < 4) ? null : data,
    );
  }

  String get posterUrl => posterPath != null
      ? 'https://image.tmdb.org/t/p/w500$posterPath'
      : 'https://placehold.co/500x750/png?text=Sem+Imagem';

  /// Só o ano, para mostrar na tela (ex.: "2024").
  String get year => releaseDate != null ? releaseDate!.substring(0, 4) : 'Sem data';
}