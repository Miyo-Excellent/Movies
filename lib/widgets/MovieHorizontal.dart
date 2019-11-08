import 'package:flutter/material.dart';
import 'package:movies_app/models/Movie.dart';
import 'package:movies_app/pages/Detail.dart';

import 'SlideRightRoute.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Movie> movies;
  final Function nextPage;

  final double _cardWidth = 100.0;

  final _pageController =
      PageController(keepPage: true, initialPage: 1, viewportFraction: 0.3);

  MovieHorizontal({@required this.movies, @required this.nextPage});

  @override
  Widget build(BuildContext context) {
    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 400) {
        nextPage();
      }
    });

    return _wrapper(context);
  }

  Widget _wrapper(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      height: _screenSize.height * 0.2,
      child: ListView.builder(
          controller: _pageController,
          scrollDirection: Axis.horizontal,
          itemCount: movies.length,
          itemBuilder: (BuildContext _context, int index) =>
              _tapped(context, index)),
    );
  }

  Widget _card(BuildContext context, int index) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      //  height: _screenSize.height * 0.19,
      constraints: BoxConstraints(
          minWidth: _cardWidth,
          maxWidth: _cardWidth,
          minHeight: _screenSize.height * 0.19,
          maxHeight: _screenSize.height * 0.19),
      margin: EdgeInsets.only(right: 10.0),
//                decoration: BoxDecoration(boxShadow: <BoxShadow>[
//                  BoxShadow(
//                    color: Colors.black,
//                    offset: Offset(1.0, 1.0),
//                    blurRadius: 1.0,
//                  ),
//                ]),
      child: Column(
        children: <Widget>[
          _image(
              context: context,
              index: index,
              image: NetworkImage(movies[index].getPosterImg())),
          _text(context: context, text: movies[index].title)
        ],
      ),
    );
  }

  Widget _tapped(BuildContext context, int index) => GestureDetector(
        child: _card(context, index),
        onTap: () => _onTap(context, movies[index]),
      );

  Widget _text({BuildContext context, String text}) => Container(
      width: _cardWidth - 10.0,
      child: Center(
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: Theme.of(context).textTheme.caption,
        ),
      ));

  Widget _image({BuildContext context, int index, ImageProvider image}) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      //  height: _screenSize.height * 0.18,
      //  margin: EdgeInsets.only(bottom: 10.0),
      constraints: BoxConstraints(
          minWidth: _cardWidth,
          maxWidth: _cardWidth,
          minHeight: _screenSize.height * 0.175,
          maxHeight: _screenSize.height * 0.175),
      child: ClipRRect(
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(10.0),
        //elevation: 2.0,
        child: FadeInImage(
          placeholder: AssetImage('lib/assets/cat_loader.gif'),
          image: image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  void _onTap(BuildContext context, Movie movie) => Navigator.push(
      context, SlideRightRoute(page: Detail(movie: movie)));
}
