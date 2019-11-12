import 'package:flutter/cupertino.dart';

class Actors {
  List<Actor> data = new List();

  Actors.fromJsonMap(List<dynamic> items) {
    if (items == null) return;
    items.forEach((actor) => data.add(Actor.fromJsonMap(actor)));
  }
}

class Actor {
  int castId;
  String character;
  String creditId;
  int gender;
  int id;
  String name;
  int order;
  String profilePath;

  Actor({
    @required castId,
    @required character,
    @required creditId,
    @required gender,
    @required id,
    @required name,
    @required order,
    @required profilePath,
  });

  Actor.fromJsonMap(Map<String, dynamic> actor) {
    castId = actor['cast_id'];
    character = actor['character'];
    creditId = actor['credit_id'];
    gender = actor['gender'];
    id = actor['id'];
    name = actor['name'];
    order = actor['order'];
    profilePath = actor['profile_path'];
  }

  getPhoto() {
    if (profilePath == null)
      return 'https://cdn.dribbble.com/users/725371/screenshots/4706510/avata_dribble.gif';
    else
      return 'https://image.tmdb.org/t/p/w500/$profilePath';
  }
}
