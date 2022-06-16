import 'package:flutter/widgets.dart';
import 'package:heal_music/screens/audio.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:on_audio_query/on_audio_query.dart';

class DbFav {
  static ValueNotifier<List<dynamic>> favourites = ValueNotifier([]);
  static dynamic favsong;
  static List<SongModel> favloop = [];

  static addSongs(item) async {
    final boxdb = await Hive.openBox('favourites');
    await boxdb.add(item);

    getAllsongs();
  }

  static getAllsongs() async {
    final boxdb = await Hive.openBox('favourites');
    favsong = boxdb.values.toList();

    displaySongs();
    favourites.notifyListeners();
  }

  static displaySongs() async {
    final boxdb = await Hive.openBox('favourites');
    final dynamic music = boxdb.values.toList();
    favourites.value.clear();
    favloop.clear();
    for (int i = 0; i < music.length; i++) {
      for (int j = 0; j < Audio.songs.length; j++) {
        if (music[i] == Audio.songs[j].id) {
          favourites.value.add(j);
          favloop.add(Audio.songs[j]);
        }
      }
    }
  }

  static deletion(index) async {
    final boxdb = await Hive.openBox('favourites');
    await boxdb.deleteAt(index);
    getAllsongs();
  }
}
