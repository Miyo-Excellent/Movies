import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movies_app/models/Actor.dart';
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

  final _popularsMoviesController = StreamController<List<Movie>>.broadcast();
  final _premieresMoviesController = StreamController<List<Movie>>.broadcast();

  Function(List<Movie>) get popularsMoviesSink =>
      _popularsMoviesController.sink.add;

  Stream<List<Movie>> get popularsMoviesStream =>
      _popularsMoviesController.stream;

  Function(List<Movie>) get premieresMoviesSink =>
      _premieresMoviesController.sink.add;

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

    return movies.items;
  }

  Future<List<Movie>> getMovieNowPlaying() async {
    if (_isFetchingPremieres) return [];

    _isFetchingPremieres = true;

    _premieres++;

    print('Premieres Is Fetching...');

    final url = Uri.https(_url, '3/movie/now_playing',
        {"api_key": _apiKey, "language": _language, "page": '$_premieres'});

    final premiers = await getMovies(url);

    _premieresMovies.addAll(premiers);

    premieresMoviesSink(_premieresMovies);

    _isFetchingPremieres = false;

    return premiers;
  }

  Future<List<Movie>> getPopulars() async {
    if (_isFetchingPopulars) return [];

    _isFetchingPopulars = true;

    _populars++;

    print('Populars Is Fetching...');

    final url = Uri.https(_url, '3/movie/popular',
        {"api_key": _apiKey, "language": _language, "page": '$_populars'});

    final response = await getMovies(url);

    _popularsMovies.addAll(response);

    popularsMoviesSink(_popularsMovies);

    _isFetchingPopulars = false;

    return response;
  }

  Future<List<Actor>> getActors(String movieId) async {
    final url = Uri.https(_url, '3/movie/$movieId/credits',
        {'api_key': _apiKey, 'language': _language});

    final response = await http.get(url);

    final responseParsed = json.decode(response.body);

    //  print(responseParsed['cast']);

    final actors = Actors.fromJsonMap(responseParsed['cast']);

    return actors.data;
  }

  Future<List<Actor>> getMovieDetails(String movieId) async {
    final url = Uri.https(_url, '3/movie/$movieId/credits',
        {'api_key': _apiKey, 'language': _language});

    final response = await http.get(url);

    final responseParsed = json.decode(response.body);

    //  print(responseParsed['cast']);

    final actors = Actors.fromJsonMap(responseParsed['cast']);

    return actors.data;
  }

  Future<List<Movie>> searchMovie(String query) async {
    final url = Uri.https(_url, '3/search/movie',
        {'api_key': _apiKey, 'language': _language, 'query': query});

    final response = await http.get(url);

    final responseParsed = json.decode(response.body);

    //  print(responseParsed['cast']);

    //  final actors = Actors.fromJsonMap(responseParsed['cast']);

    //  print(responseParsed['results']);
    //  print('=======================================================================');

    if (responseParsed['status_code'] == 34) return [];

    final movies = Movies.fromJsonList(responseParsed['results']);

    return movies.items;
  }
}
