class Movies {
  List<Movie> items = new List();

  Movies();

  Movies.fromJsonList(List<dynamic> movies) {
    if (movies == null) return;

    for (final movie in movies) {
      items.add(Movie.fromJsonMap(movie));
    }
  }
}

class Movie {
  String uniqueId;
  int voteCount;
  int id;
  bool video;
  double voteAverage;
  String title;
  double popularity;
  String posterPath;
  String backdropPath;
  String originalLanguage;
  String originalTitle;
  List<int> genreIds;
  bool adult;
  String overview;
  String releaseDate;

  Movie(
      {this.voteCount,
      this.id,
      this.video,
      this.voteAverage,
      this.title,
      this.popularity,
      this.backdropPath,
      this.posterPath,
      this.originalLanguage,
      this.originalTitle,
      this.adult,
      this.overview,
      this.releaseDate});

  Movie.fromJsonMap(Map<String, dynamic> json) {
    voteCount = json["vote_count"];
    id = json["id"];
    video = json["video"];
    voteAverage = json["vote_average"] / 1;
    title = json["title"];
    popularity = json["popularity"] / 1;
    backdropPath = json["backdrop_path"];
    posterPath = json["poster_path"];
    originalLanguage = json["original_anguage"];
    originalTitle = json["original_title"];
    genreIds = json["genre_ids"].cast<int>();
    adult = json["adult"];
    overview = json["overview"];
    releaseDate = json["release_date"];
  }

  getBackgroundImg() => posterPath != null
      ? 'https://image.tmdb.org/t/p/w500/$backdropPath'
      : 'https://zenit.org/wp-content/uploads/2018/05/no-image-icon.png';

  getPosterImg() => posterPath != null
      ? 'https://image.tmdb.org/t/p/w500/$posterPath'
      : 'https://zenit.org/wp-content/uploads/2018/05/no-image-icon.png';
}
