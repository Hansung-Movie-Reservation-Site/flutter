class Movie {
  final int id;
  final int tmdbMovieId;
  final String kobisMovieCd;
  final String title;
  final String posterImage;
  final String overview;
  final String director;
  final String genres;
  final String releaseDate;
  final int runtime;
  final int boxOfficeRank;
  final int rankInten;
  final String rankOldAndNew;
  final int audiAcc;
  final String fullVideoLink;
  final String fetchedDate;

  Movie({
    required this.id,
    required this.tmdbMovieId,
    required this.kobisMovieCd,
    required this.title,
    required this.posterImage,
    required this.overview,
    required this.director,
    required this.genres,
    required this.releaseDate,
    required this.runtime,
    required this.boxOfficeRank,
    required this.rankInten,
    required this.rankOldAndNew,
    required this.audiAcc,
    required this.fullVideoLink,
    required this.fetchedDate,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      tmdbMovieId: json['tmdbMovieId'],
      kobisMovieCd: json['kobisMovieCd'],
      title: json['title'],
      posterImage: json['posterImage'],
      overview: json['overview'],
      director: json['director'],
      genres: json['genres'],
      releaseDate: json['releaseDate'],
      runtime: json['runtime'],
      boxOfficeRank: json['boxOfficeRank'],
      rankInten: json['rankInten'],
      rankOldAndNew: json['rankOldAndNew'],
      audiAcc: json['audiAcc'],
      fullVideoLink: json['full_video_link'],
      fetchedDate: json['fetchedDate'],
    );
  }
}