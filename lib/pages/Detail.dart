import 'package:flutter/material.dart';
import 'package:movies_app/models/Actor.dart';
import 'package:movies_app/models/Movie.dart';
import 'package:movies_app/providers/Movies.dart';

class Detail extends StatelessWidget {
  final MoviesProvider moviesProvider = MoviesProvider();

  final Movie movie;
  final double _backgroundImgSize = 300.0;

  Detail({@required this.movie});

  @override
  Widget build(BuildContext context) {
    //  final Movie movie = ModalRoute.of(context).settings.arguments;
    print(movie.id);

    return Scaffold(
        body: CustomScrollView(
      scrollDirection: Axis.vertical,
      slivers: <Widget>[
        _appBar(context, movie, Colors.black),
        _body(context, movie)
      ],
    ));
  }

  Widget _appBar(BuildContext context, Movie movie, Color color) {
    final _screenSize = MediaQuery.of(context).size;

    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: color,
//      title: Container(
//        color: Color.fromRGBO(0, 0, 0, 0.0),
//        child: Center(
//          child: Text(movie.title),
//        ),
//      ),
      expandedHeight: 251,
      centerTitle: true,
      forceElevated: true,
      automaticallyImplyLeading: true,
      floating: true,
      //  pinned: true,
      flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: Container(
            color: Color.fromRGBO(0, 0, 0, 0.0),
            child: Container(
              padding: EdgeInsets.only(top: 50.0),
              child: Center(
                child: Text(movie.title),
              ),
            ),
          ),
          background: Container(
              width: _screenSize.width,
              height: _screenSize.height,
              child: _background(context))),
    );
  }

  Widget _background(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            FadeInImage(
              height: _backgroundImgSize,
              width: _screenSize.width,
              fit: BoxFit.cover,
              placeholder: AssetImage('lib/assets/liquid-loading.gif'),
              image: NetworkImage(movie.getBackgroundImg()),
            ),
          ],
        ),
        Container(
          color: Color.fromRGBO(0, 0, 0, 0.2),
          height: _backgroundImgSize,
          width: _screenSize.width,
        )
      ],
    );
  }

  Widget _poster(String posterUri) => Hero(
        tag: movie.uniqueId,
        child: ClipRRect(
          //  Poster
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            width: 145.0,
            child: FadeInImage(
              placeholder: AssetImage('lib/assets/liquid-loading.gif'),
              image: NetworkImage(posterUri),
            ),
          ),
        ),
      );

  Widget _overview(BuildContext context, String title, String subTitle) =>
      Flexible(
        flex: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  title,
                  style: Theme.of(context).textTheme.title,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            SizedBox(height: 3.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  subTitle,
                  style: Theme.of(context).textTheme.subhead,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            SizedBox(height: 3.0),
            Text(movie.releaseDate, style: Theme.of(context).textTheme.caption),
            SizedBox(height: 3.0),
            _voteAverageStars(context, movie.voteAverage.toString())
          ],
        ),
      );

  Widget _description(BuildContext context, String text) => Container(
        margin: EdgeInsets.only(bottom: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Center(
            child: Text(text,
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.body1)),
      );

  _voteAverageStars(BuildContext context, String voteAverage) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.star, color: Colors.amberAccent, size: 25.0),
              Icon(Icons.star, color: Colors.amberAccent, size: 25.0),
              Icon(Icons.star, color: Colors.amberAccent, size: 25.0),
              Icon(Icons.star, color: Colors.amberAccent, size: 25.0),
              Icon(Icons.star_half, color: Colors.amberAccent, size: 25.0),
            ],
          ),
          SizedBox(width: 10.0),
          Text(voteAverage, style: Theme.of(context).textTheme.subhead),
        ],
      );

  Widget _actors(BuildContext context, Movie movie) {
    //  print('ID: ${movie.id.toString()}');

    return FutureBuilder(
      future: moviesProvider.getActors(movie.id.toString()),
      builder: (BuildContext builderContext, AsyncSnapshot<List> snapshot) {
        final List<Actor> actors = snapshot.data;

        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );

        return SizedBox(
          height: 200.0,
          child: PageView.builder(
              itemCount: actors.length,
              controller: PageController(initialPage: 1, viewportFraction: 0.3),
              itemBuilder: (BuildContext itemBuilderContext, int index) =>
                  _actor(context, actors[index])),
        );
      },
    );
  }

  Widget _actor(BuildContext context, Actor actor) => Container(
      width: 140.0,
      padding: EdgeInsets.all(5.0),
      margin: EdgeInsets.only(right: 10.0),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: FadeInImage(
              height: 170.0,
              fit: BoxFit.cover,
              image: NetworkImage(actor.getPhoto()),
              placeholder: AssetImage('lib/assets/liquid-loading.gif'),
            ),
          ),
          Container(
            width: 130.0,
            child: Center(
              child: Text(
                actor.name,
                style: Theme.of(context).textTheme.caption,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
        ],
      ));

  Widget _body(BuildContext context, Movie movie) {
    final _screenSize = MediaQuery.of(context).size;
    final double _contentSize = _screenSize.height -
        (_backgroundImgSize - (_screenSize.height * 0.228));

    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Container(
            padding: EdgeInsets.all(10.0),
            color: Color.fromRGBO(245, 245, 245, 1.0),
            constraints: BoxConstraints(minHeight: _contentSize),
            //  height: _contentSize,
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 20.0),
                  child: Row(
                    children: <Widget>[
                      _poster(movie.getPosterImg()),
                      SizedBox(width: 10.0),
                      _overview(
                        context,
                        movie.title,
                        movie.originalTitle,
                      ),
                    ],
                  ),
                ),
                _description(context, movie.overview),
                _actors(context, movie)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
