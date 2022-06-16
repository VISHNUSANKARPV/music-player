import 'package:flutter/material.dart';
import 'package:heal_music/playlist/addallsongs.dart';
import 'package:heal_music/playlist/db/function.dart';
import 'package:heal_music/screens/audio.dart';
import 'package:heal_music/screens/now_playing.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'db/datamodel.dart';

class MusicList extends StatefulWidget {
  MusicList({Key? key, required this.folderindex}) : super(key: key);

  dynamic folderindex;

  @override
  State<MusicList> createState() => _MusicListState();
}

class _MusicListState extends State<MusicList> {
  List<dynamic> dltlist = [];
  List<dynamic> songlist = [];
  @override
  Widget build(BuildContext context) {
    PlaylistFunctions.getPlaylist();
    PlaylistSongcheck.showselectedsong(widget.folderindex);
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'lib/assets/HD-wallpaper-guitar-leaf-dry-green-macro.jpg',
              ),
              fit: BoxFit.cover)),
      child: Scaffold(
        // extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 25,
              )),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            PlaylistFunctions.playlistsongs.value[widget.folderindex].name
                .toString(),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((ctx) => AddSongs(
                            newindex: widget.folderindex,
                          ))));
                },
                icon: const Icon(
                  Icons.add_outlined,
                  color: Colors.white,
                ))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ValueListenableBuilder(
            valueListenable: PlaylistFunctions.playlistsongs,
            builder:
                (BuildContext context, List<dynamic> value, Widget? child) {
              return ListView.builder(
                itemCount: PlaylistFunctions
                    .playlistsongs.value[widget.folderindex].songlistdb.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: ()  {
                       Audio.paattu.setAudioSource(
                          createPlaylist(PlaylistFunctions.playloop),
                          initialIndex: index);

                     

                       Audio.paattu.play();

                       Navigator.of(context).push(MaterialPageRoute(
                          builder: ((ctx) => Playing(
                                loopsong: PlaylistFunctions.playloop,
                              ))));
                    },
                    child: ListTile(
                        leading: QueryArtworkWidget(
                            id: Audio
                                .songs[PlaylistSongcheck
                                    .selectplaysong.value[index]]
                                .id,
                            type: ArtworkType.AUDIO),
                        title: Text(
                          Audio
                              .songs[
                                  PlaylistSongcheck.selectplaysong.value[index]]
                              .title,
                          style: const TextStyle(color: Colors.white),
                          // maxLines: 1,
                           overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          Audio
                              .songs[
                                  PlaylistSongcheck.selectplaysong.value[index]]
                              .artist.toString(),
                          style: const TextStyle(color: Colors.white),
                          // maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                            onPressed: () {
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
                                        setState(() {});
                              PlaylistFunctions.playlistsongs
                                  .value[widget.folderindex].songlistdb
                                  .removeAt(index);
                              dltlist = [
                                songlist,
                                PlaylistFunctions.playlistsongs
                                    .value[widget.folderindex].songlistdb
                              ].expand((element) => element).toList();

                              final model = MusicModel(
                                name: PlaylistFunctions.playlistsongs
                                    .value[widget.folderindex].name,
                                songlistdb: dltlist,
                              );
                              PlaylistFunctions.updateList(
                                  widget.folderindex, model);
                                        const snackBar = SnackBar(
                                            content:
                                                Text('Removed from the playlist'));
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
                            icon:  Icon(Icons.circle_outlined,color: Colors.red.shade200,))),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
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
 