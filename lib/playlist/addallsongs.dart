import 'package:flutter/material.dart';
import 'package:heal_music/playlist/addbuttons.dart';
import 'package:heal_music/playlist/db/function.dart';
import 'package:heal_music/screens/audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AddSongs extends StatelessWidget {
  AddSongs({Key? key, this.newindex}) : super(key: key);

  dynamic newindex;
  @override
  Widget build(BuildContext context) {
    PlaylistSongcheck.showselectedsong(newindex);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Addsongs',style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold),),
          
          backgroundColor: Colors.transparent,
            leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios_new,color: Colors.white,size: 20,)),
        ),
        
        backgroundColor: Colors.transparent,
        body: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: Audio.songs.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: QueryArtworkWidget(
                  id: Audio.songs[index].id, type: ArtworkType.AUDIO),
              title: Text(Audio.songs[index].title,style: const TextStyle(color: Colors.white),maxLines: 2,),
              trailing: PlaylistButton(
                  index: index,
                  folderindex: newindex,
                  songindex: Audio.songs[index].id),
            );
          },
          
        ),
        // floatingActionButton: FloatingActionButton(onPressed: () {
        //   setsta
        // },child: Icon(Icons.refresh),),
      ),
    );
  }
}
