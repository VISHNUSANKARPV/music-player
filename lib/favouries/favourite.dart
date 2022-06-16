import 'package:flutter/material.dart';
import 'package:heal_music/favouries/dbfunctions/function.dart';
import 'package:heal_music/screens/audio.dart';
import 'package:heal_music/screens/now_playing.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Favourite extends StatelessWidget {
  const Favourite({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DbFav.getAllsongs();
    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image:
                  AssetImage('lib/assets/wp2584647-guitar-red-wallpaper.jpg'),
              fit: BoxFit.cover),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text(
              'Favourites',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
          ),
          body: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.transparent,
            child: ValueListenableBuilder(
              valueListenable: DbFav.favourites,
              builder:
                  (BuildContext context, List<dynamic> value, Widget? child) {
                return ListView.builder(
                  itemCount: value.length,
                  // ignore: dead_code
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: QueryArtworkWidget(
                          id: Audio.songs[value[index]].id,
                          type: ArtworkType.AUDIO),
                      title: Text(Audio.songs[value[index]].title,
                          style: const TextStyle(color: Colors.white),
                          overflow: TextOverflow.ellipsis),
                      subtitle: Text(
                        Audio.songs[value[index]].artist.toString(),
                        style: const TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                        onPressed: ()  {
                          // DbFav.deletion(index);
                          showDialog(
                            context: context,
                            builder: (BuildContext ctx) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                // title: const Text(
                                //     'do you want to remove the song?'),
                                content: const Text(
                                  'Do you want to remove the song?',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },
                                      child: const Text('Cancel')),
                                  TextButton(
                                      onPressed: () {
                                        DbFav.deletion(index);
                                        const snackBar = SnackBar(
                                            content:
                                                Text('Remove from favourites'));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                        Navigator.of(ctx).pop();
                                      },
                                      child: const Text('Yes'))
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.green,
                        ),
                      ),
                      onTap: () {
                        List<SongModel> newfav = [];
                        Audio.paattu.setAudioSource(
                            createPlaylist(DbFav.favloop),
                            initialIndex: index);
                        newfav.addAll(DbFav.favloop);
                        Audio.paattu.play();

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: ((ctx) => Playing(
                                  loopsong: newfav,
                                ))));
                      },
                    );
                  },
                );
              },
            ),
          ),
        ));
  }

  ConcatenatingAudioSource createPlaylist(List<SongModel> songs) {
    List<AudioSource> sources = [];
    for (var song in songs) {
      sources.add(AudioSource.uri(Uri.parse(song.uri!),
          tag: MediaItem(
              id: song.id.toString(),
              title: song.title,
              artUri: Uri.parse('lib/assets/apple-music-note.jpg'))));
    }
    return ConcatenatingAudioSource(children: sources);
  }
}
