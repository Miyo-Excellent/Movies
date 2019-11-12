import 'package:flutter/material.dart';
import 'package:movies_app/models/Movie.dart';
import 'package:movies_app/pages/Detail.dart';
import 'package:movies_app/providers/Movies.dart';
import 'package:movies_app/widgets/SlideRightRoute.dart';

class DataSearch extends SearchDelegate {
  final MoviesProvider _provider = MoviesProvider();
  final ScrollController _controller = ScrollController();

  String _selected;

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: AnimatedIcon(
          progress: transitionAnimation,
          icon: AnimatedIcons.menu_arrow,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(_selected),
      ),
    );
  }

//  @override
//  Widget buildSuggestions(BuildContext context) {
//    // TODO: implement buildSuggestions
//    final suggestions = (query.isEmpty)
//        ? populars
//        : movies
//            .where((m) =>
//                m.toString().toLowerCase().startsWith(query.toLowerCase()))
//            .toList();
//
//    return ListView.builder(
//      itemCount: suggestions.length,
//      controller: _controller,
//      itemBuilder: (BuildContext itemBuilderContext, int index) => ListTile(
//        title: Text(suggestions[index]),
//        leading: AnimatedIcon(
//          progress: transitionAnimation,
//          icon: AnimatedIcons.list_view,
//        ),
//        onTap: () {
//         //  _selected = suggestions[index];
//         //  showResults(context);
//        },
//      ),
//    );
//  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions

    if (query.isEmpty) return Container();

    return FutureBuilder(
      future: _provider.searchMovie(query),
      builder:
          (BuildContext builderContext, AsyncSnapshot<List<Movie>> snapshot) {
            //  print(snapshot.data);

        if (!snapshot.hasData) return CircularProgressIndicator();

        return ListView(
          children: snapshot.data
              .map((Movie movie) => ListTile(
                    title: Text(movie.title,
                        style: Theme.of(context).textTheme.subhead),
                    leading: Container(
                      width: 50.0,
//                      decoration: BoxDecoration(
//                        boxShadow: [
//                          new BoxShadow(
//                            color: Color.fromRGBO(100, 100, 100, 0.5),
//                            offset: new Offset(1.5, 1.5),
//                            blurRadius: 3.0,
//                          )
//                        ],
//                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2.0),
                        child: FadeInImage(
                          width: 50.0,
                          fit: BoxFit.cover,
                          placeholder: AssetImage('lib/assets/liquid-loading.gif'),
                          image: NetworkImage(movie.getPosterImg()),
                        ),
                      ),
                    ),
                    subtitle: Text(movie.releaseDate,
                        style: Theme.of(context).textTheme.caption),
                    onTap: () {
                      movie.uniqueId = '${movie.id}-search';
                      close(context, null);
                      Navigator.push(context, SlideRightRoute(page: Detail(movie: movie)));
                    },
                  ))
              .toList(),
        );
      },
    );
  }
}
