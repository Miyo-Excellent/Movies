import 'package:flutter/material.dart';
import 'package:movies_app/providers/Movies.dart';
import 'package:movies_app/search/Delegate.dart';
import 'package:movies_app/widgets/CardSwiper.dart';
import 'package:movies_app/widgets/MovieHorizontal.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final MoviesProvider moviesProvider = MoviesProvider();

  @override
  void initState() {
    super.initState();
    moviesProvider.getPopulars();
    moviesProvider.getMovieNowPlaying();
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: Text('Movies'),
          backgroundColor: Colors.amber,
          actions: <Widget>[
            IconButton(
              highlightColor: Colors.amber[600],
              splashColor: Colors.amber[800],
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
              },
              icon: Icon(Icons.search),
            )
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: _screenSize.width,
                height: _screenSize.height * 0.6,
                //  child: CardSwiper(movies: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9])
                child: StreamBuilder(
                  stream: moviesProvider.popularsMoviesStream,
                  builder:
                      (BuildContext context, AsyncSnapshot<List> snapshot) =>
                          snapshot.hasData
                              ? CardSwiper(
                                  movies: snapshot.data,
                                  nextPage: moviesProvider.getPopulars)
                              : _loader(),
                ),
              ),
              Container(
                width: double.infinity,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 10.0),
                      margin: EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Popularity',
                            style: Theme.of(context).textTheme.subhead,
                          ),
                        ],
                      ),
                    ),
                    StreamBuilder(
                        stream: moviesProvider.premieresMoviesStream,
                        builder: (BuildContext _context,
                                AsyncSnapshot<List> snapshot) =>
                            snapshot.hasData
                                ? MovieHorizontal(
                                    movies: snapshot.data,
                                    nextPage: moviesProvider.getMovieNowPlaying,
                                  )
                                : Container())
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Widget _loader() => Container(
        width: 200.0,
        height: 200.0,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
}
