import 'package:flutter/material.dart';
import 'package:movies_app/providers/Movies.dart';
import 'package:movies_app/widgets/CardSwiper.dart';
import 'package:movies_app/widgets/MovieHorizontal.dart';

class Home extends StatelessWidget {
  final MoviesProvider moviesProvider = MoviesProvider();

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    moviesProvider.getPopulars();
    moviesProvider.getMovieNowPlaying();

    return Scaffold(
//        appBar: AppBar(
//          title: Text('Movies'),
//          backgroundColor: Colors.amber,
//          actions: <Widget>[
//            IconButton(
//              onPressed: () {},
//              icon: Icon(Icons.search),
//            )
//          ],
//        ),
        body: Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: _screenSize.width,
            height: _screenSize.height * 0.7,
            //  child: CardSwiper(movies: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9])
            child: StreamBuilder(
              stream: moviesProvider.premieresMoviesStream,
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) =>
                  snapshot.hasData
                      ? CardSwiper(
                          movies: snapshot.data,
                          nextPage: moviesProvider.getMovieNowPlaying)
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
                    stream: moviesProvider.popularsMoviesStream,
                    builder:
                        (BuildContext _context, AsyncSnapshot<List> snapshot) =>
                            snapshot.hasData
                                ? MovieHorizontal(
                                    movies: snapshot.data,
                                    nextPage: moviesProvider.getPopulars,
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
