import 'package:flutter/material.dart';
import 'package:heal_music/playlist/db/datamodel.dart';
import 'package:heal_music/playlist/db/function.dart';
import 'package:heal_music/screens/audio.dart';

class PlaylistButton extends StatefulWidget {
  PlaylistButton(
      {Key? key,
      required this.index,
      required this.folderindex,
      required this.songindex})
      : super(key: key);

  int index;
  int folderindex;
  int songindex;
 
  @override
  State<PlaylistButton> createState() => _PlaylistButtonState();
}

class _PlaylistButtonState extends State<PlaylistButton> {
  @override
  Widget build(BuildContext context) {
     List<dynamic> songlist = [];
  List<dynamic> updatelist = [];
  List<dynamic> dltlist = [];

    final checkIndex = PlaylistFunctions.playlistsongs.value[widget.folderindex].songlistdb.contains(widget.songindex);
    final indexCheck = PlaylistFunctions.playlistsongs.value[widget.folderindex].songlistdb.indexWhere((element) => element == Audio.songs[widget.index].id);
    if (checkIndex != true) {
      return IconButton(
          onPressed: () async {
            songlist.add(Audio.songs[widget.index].id);
            updatelist = [
              songlist,
              PlaylistFunctions.playlistsongs.value[widget.folderindex].songlistdb].expand((element) => element).toList();
            final model = MusicModel(
              name: PlaylistFunctions
                  .playlistsongs.value[widget.folderindex].name,
              songlistdb: updatelist,
            );
           await PlaylistFunctions.updateList(widget.folderindex, model);
            PlaylistSongcheck.showselectedsong(widget.folderindex);
            setState(() {});
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //     content: Text(
            //       'added song to the playlist ${PlaylistFunctions.playlistsongs.value[widget.folderindex!].name},',
            //       style: const TextStyle(color: Colors.white),
            //     ),
            //     backgroundColor: const Color.fromARGB(255, 62, 62, 62),
            //     behavior: SnackBarBehavior.floating,
            //   ),
            // );
          },
          icon: const Icon(
            Icons.circle_outlined,
            color: Color.fromARGB(255, 135, 255, 145),
          ));
    }
    return IconButton (
        onPressed: () {
            setState(() {});
         PlaylistFunctions.playlistsongs.value[widget.folderindex].songlistdb.removeAt(indexCheck);
        dltlist = [songlist,  PlaylistFunctions.playlistsongs.value[widget.folderindex].songlistdb].expand((element) => element).toList();

          final model = MusicModel( name: PlaylistFunctions.playlistsongs.value[widget.folderindex].name,songlistdb: dltlist, );
          PlaylistFunctions.updateList(widget.folderindex, model);
          //  PlaylistSongcheck.showselectedsong(widget.folderindex);

        
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text(
          //       'song deleted from the playlist  ${PlaylistFunctions.playlistsongs.value[widget.folderindex!].name},',
          //       style: const TextStyle(color: Colors.white),
          //     ),
          //     backgroundColor: const Color.fromARGB(255, 68, 68, 68),
          //     behavior: SnackBarBehavior.floating,
          //   ),
          // );
        },
        icon: Icon(
          Icons.circle_outlined,
          color: Colors.red.shade200,
        ));
  }
}
