import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movies_app/models/Movie.dart';

class CardSwiper extends StatelessWidget {
  final List<Movie> movies;
  final Function nextPage;

  CardSwiper({@required this.movies, @required this.nextPage});
  final _controller = SwiperController();

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _controller.addListener(() {
      print(_controller.index);
      print(movies.length - 1);

      if (_controller.index == (movies.length - 3)) {
        nextPage();
      }
    });

    return Swiper(
      controller: _controller,
      itemBuilder: (BuildContext context, int index) => ClipRRect(
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(15.5),
          //  elevation: 2.5,
          child: FadeInImage(
            placeholder: AssetImage('lib/assets/cat_loader.gif'),
            fadeInDuration: Duration(milliseconds: 350),
            image: NetworkImage(movies[index].getPosterImg()),
            fit: BoxFit.cover,
          )),
      itemCount: movies.length,
      itemWidth: _screenSize.width * 0.75,
      itemHeight: _screenSize.height * 0.6,
      //  pagination: SwiperPagination(),
      layout: SwiperLayout.STACK,
      //  control: SwiperControl(),
    );
  }
}
