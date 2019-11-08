import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movies_app/models/Movie.dart';

class MoviesProvider {
  String _apiKey = "77c6664896a34c14b128e5400af37e51";
  String _url = "api.themoviedb.org";
  String _language = "es-ES";
  int _page = 1;
  int _listId = 1;

  int _populars = 0;
  int _premieres = 0;

  bool _isFetchingPopulars = false;
  bool _isFetchingPremieres = false;

  List<Movie> _popularsMovies = new List();
  List<Movie> _premieresMovies = new List();

  // ignore: close_sinks
  final _popularsMoviesController = StreamController<List<Movie>>.broadcast();
  final _premieresMoviesController = StreamController<List<Movie>>.broadcast();

  Function(List<Movie>) get popularsMoviesSink =>
      _popularsMoviesController.sink.add;

  Function(List<Movie>) get premieresMoviesSink =>
      _premieresMoviesController.sink.add;

  Stream<List<Movie>> get popularsMoviesStream =>
      _popularsMoviesController.stream;

  Stream<List<Movie>> get premieresMoviesStream =>
      _premieresMoviesController.stream;

  void disposeStreams() {
    _popularsMoviesController?.close();
    _premieresMoviesController?.close();
  }

  Future<List<Movie>> getMovies(Uri url) async {
    final response = await http.get(url);
    final decodeResponse = await json.decode(response.body);
    final movies = Movies.fromJsonList(decodeResponse["results"]);

    _premieresMovies.addAll(movies.items);

    premieresMoviesSink(_premieresMovies);

    return movies.items;
  }

  Future<List<Movie>> getMovieNowPlaying() async {
    if (_isFetchingPremieres) return [];

    _isFetchingPremieres = true;

    final url = Uri.https(_url, '3/movie/now_playing',
        {"api_key": _apiKey, "language": _language, "page": '$_premieres'});

    final response = await getMovies(url);

    _isFetchingPremieres = false;

    return response;
  }

  Future<List<Movie>> getPopulars() async {
    if (_isFetchingPopulars) return [];

    _isFetchingPopulars = true;

    _populars++;

    print('Is Fetching...');

    final url = Uri.https(_url, '3/movie/popular',
        {"api_key": _apiKey, "language": _language, "page": '$_populars'});

    final response = await getMovies(url);

    _popularsMovies.addAll(response);

    popularsMoviesSink(_popularsMovies);

    _isFetchingPopulars = false;

    return response;
  }
}
