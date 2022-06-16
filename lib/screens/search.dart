import 'package:flutter/material.dart';
import 'package:heal_music/screens/audio.dart';
import 'package:heal_music/screens/now_playing.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:just_audio/just_audio.dart';

ValueNotifier<List<SongModel>> temp = ValueNotifier([]);

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);

  static dynamic searchindex = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: TextField(
          onChanged: (String? value) {
            if (value == null || value.isEmpty) {
              temp.value.addAll(Audio.songs);
            } else {
              temp.value.clear();
              for (SongModel ind in Audio.songs) {
                if (ind.title.toLowerCase().contains(value.toLowerCase())) {
                  temp.value.add(ind);
                }
              }
            }
            temp.notifyListeners();
          },
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'search here',
              prefixIcon: const Icon(Icons.search),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
        ),
      ),
      body: SafeArea(
          child: ListView(
        children: [
          Column(
            children: [
              SizedBox(
                height: double.maxFinite,
                child: ValueListenableBuilder(
                  valueListenable: temp,
                  builder: (BuildContext context, List<SongModel> searchdata,
                      Widget? child) {
                    return ListView.builder(
                      itemCount: searchdata.length,
                      itemBuilder: (BuildContext context, int index) {
                        final data = searchdata[index];
                        return ListTile(
                          leading: QueryArtworkWidget(
                              id: data.id, type: ArtworkType.AUDIO),
                          title: Text(
                            data.title,
                            style: const TextStyle(color: Colors.white),
                          ),
                          onTap: ()  {
                           

                            FocusScope.of(context).unfocus();

                            int songindex = indexpassing(data);
                             Audio.paattu.setAudioSource(
                                createPlaylist(Audio.songs),
                                initialIndex: songindex);
                             Audio.paattu.play();

                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Playing(
                                      loopsong: Audio.songs,
                                    )));
                          },
                        );
                      },
                    );
                  },
                ),
              )
            ],
          )
        ],
      )),
    );
  }

  ConcatenatingAudioSource createPlaylist(List<SongModel> songs) {
    List<AudioSource> sources = [];
    for (var song in songs) {
      sources.add(AudioSource.uri(Uri.parse(
        song.uri!,
      ),  tag: MediaItem(
              id: song.id.toString(),
              title: song.title,)));
    }
    return ConcatenatingAudioSource(children: sources);
  }

  indexpassing(
    data,
  ) {
    int? searchindex;
    for (int i = 0; i < Audio.songs.length; i++) {
      if (data.id == Audio.songs[i].id) {
        searchindex = i;
      }
    }
    return searchindex;
  }
}
