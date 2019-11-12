import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movies_app/models/Movie.dart';
import 'package:movies_app/pages/Detail.dart';

import 'SlideRightRoute.dart';

class CardSwiper extends StatefulWidget {
  final List<Movie> movies;
  final Function nextPage;

  CardSwiper({@required this.movies, @required this.nextPage});

  @override
  _CardSwiperState createState() =>
      _CardSwiperState(nextPage: nextPage, movies: movies);
}

class _CardSwiperState extends State<CardSwiper> {
  final List<Movie> movies;
  final Function nextPage;

  final SwiperController _controller = SwiperController();

  _CardSwiperState({@required this.movies, @required this.nextPage});

  @override
  void initState() {
    super.initState();

    //  _controller.startAutoplay();

    _controller.addListener(() {
      print('TEST');
    });
//
//    _controller.addListener(() {
//
//      if (_controller.index == (movies.length - 3)) {
//        print('TEST');
//        print(_controller.index);
//        print(movies.length);
//        nextPage();
//      }
//    });
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    void goToMovieDetails(Movie movie) {
      Navigator.push(
          context,
          SlideRightRoute(
              page: Detail(
            movie: movie,
          )));
    }

    return Swiper(
      controller: _controller,
      itemBuilder: (BuildContext itemBuilderContext, int index) {
        final Movie _movie = movies[index];

        _movie.uniqueId = '${_movie.id}-swiper';

        return Hero(
          tag: _movie.uniqueId,
          child: GestureDetector(
            onTap: () => goToMovieDetails(_movie),
            child: ClipRRect(
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(15.5),
                //  elevation: 2.5,
                child: FadeInImage(
                  placeholder: AssetImage('lib/assets/liquid-loading.gif'),
                  fadeInDuration: Duration(milliseconds: 350),
                  image: NetworkImage(_movie.getPosterImg()),
                  fit: BoxFit.cover,
                )),
          ),
        );
      },
      itemCount: movies.length,
      itemWidth: _screenSize.width * 0.75,
      itemHeight: _screenSize.height * 0.6,
      //  pagination: SwiperPagination(),
      layout: SwiperLayout.STACK,
      //  control: SwiperControl(),
    );
  }
}
