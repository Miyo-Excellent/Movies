import 'package:flutter/material.dart';
import 'package:movies_app/models/Movie.dart';

class Detail extends StatelessWidget {
  final Movie movie;
  final double _backgroundImgSize = 300.0;

  Detail({@required this.movie});

  @override
  Widget build(BuildContext context) {
    //  final Movie movie = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        body: CustomScrollView(
      scrollDirection: Axis.vertical,
      slivers: <Widget>[
        _appBar(context, movie, Colors.deepPurple[600]),
        _body(context, movie)
      ],
    ));
  }

  _appBar(BuildContext context, Movie movie, Color color) {
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
      expandedHeight: _screenSize.height,
      centerTitle: true,
      forceElevated: true,
      automaticallyImplyLeading: true,
      floating: true,
      //  pinned: true,
      flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: Container(
            color: Color.fromRGBO(0, 0, 0, 0.0),
            child: Center(
              child: Text(movie.title),
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
              placeholder: AssetImage('lib/assets/cat_loader.gif'),
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

  Widget _body(BuildContext context, Movie movie) {
    final _screenSize = MediaQuery.of(context).size;

    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Container(
            color: Colors.red,
            height: _screenSize.height - (_backgroundImgSize - (_screenSize.height * 0.228))
          )
        ],
      ),
    );
  }
}
