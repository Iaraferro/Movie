class Movie {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final double voteAverage;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    required this.voteAverage,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Sem título',
      overview: json['overview'] ?? 'Sem descrição disponível.',
      posterPath: json['poster_path'],
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
    );
  }

  String get posterUrl => posterPath != null
      ? 'https://image.tmdb.org/t/p/w500$posterPath'
      : 'https://via.placeholder.com/500x750?text=Sem+Imagem';
}