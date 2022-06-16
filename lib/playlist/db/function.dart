import 'package:flutter/material.dart';
import 'package:heal_music/playlist/db/datamodel.dart';
import 'package:heal_music/screens/audio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlaylistFunctions {
  static ValueNotifier<List<MusicModel>> playlistsongs = ValueNotifier([]);

  static List<SongModel> playloop = [];

  static addPlalist({required MusicModel model}) async {
    final playlistDb = await Hive.openBox<MusicModel>('playlistsongs');
    await playlistDb.add(model);
    getPlaylist();
  }

  static getPlaylist() async {
    final playlistDb = await Hive.openBox<MusicModel>('playlistsongs');
    playlistsongs.value.clear();
    playlistsongs.value.addAll(playlistDb.values);
    playlistsongs.notifyListeners();
  }

  static updateList(index, model) async {
    final playlistDb = await Hive.openBox<MusicModel>('playlistsongs');
    await playlistDb.putAt(index, model);
    await getPlaylist();

    await PlaylistSongcheck.showselectedsong(index);
  }

  static deletplaylist(index) async {
    final playlistDb = await Hive.openBox<MusicModel>('playlistsongs');
    await playlistDb.deleteAt(index);
    getPlaylist();
  }
}

class PlaylistSongcheck {
  static ValueNotifier<List> selectplaysong = ValueNotifier([]);

  static showselectedsong(index)  {
    final checksong = PlaylistFunctions.playlistsongs.value[index].songlistdb;
    selectplaysong.value.clear();
    PlaylistFunctions.playloop.clear();
    for (int i = 0; i < checksong.length; i++) {
      for (int j = 0; j < Audio.songs.length; j++) {
        if (Audio.songs[j].id == checksong[i]) {
          selectplaysong.value.add(j);
          PlaylistFunctions.playloop.add(Audio.songs[j]);
          break;
        }
      }
    }
   
  }
}
