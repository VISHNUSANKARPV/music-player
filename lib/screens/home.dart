import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heal_music/favouries/button.dart';
import 'package:heal_music/favouries/dbfunctions/function.dart';
import 'package:heal_music/screens/audio.dart';
import 'package:heal_music/screens/now_playing.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}


class _HomeState extends State<Home> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    DbFav.getAllsongs();
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image:
                  AssetImage('lib/assets/HD-wallpaper-guitar-leaf-dry-green-macro.jpg'),
              fit: BoxFit.cover)),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              AppBar(
                  title: Text(
                    "Heal Music",
                    style: TextStyle(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  backgroundColor: Colors.transparent),

              //<.........//  query music in external storage of device //..........>//

              FutureBuilder<List<SongModel>>(
                future: _audioQuery.querySongs(
                    sortType: null,
                    orderType: OrderType.ASC_OR_SMALLER,
                    uriType: UriType.EXTERNAL,
                    ignoreCase: true),
                builder: (context, item) {
                  if (item.data == null) {
                    return const Text('.');
                  }

                  if (item.data!.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 30, top: 20).r,
                      child: Text(
                        'No Songs found!',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 50.sp,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                  Audio.songs = item.data!;
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 10),
                    itemCount: item.data!.length,
                    shrinkWrap: true,
                    primary: false,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 15).r,
                        child: InkWell(
                          onTap: ()  {
                          

                             Audio.paattu.setAudioSource(
                                createPlaylist(item.data!),
                                initialIndex: index);

                             Audio.paattu.play();

                              Navigator.of(context).push(MaterialPageRoute(
                                builder: ((ctx) => Playing(
                                      loopsong: Audio.songs,
                                    ))));
                          },
                          child: Card(
                            color: Colors.transparent,
                            child: Column(
                              children: [
                                Center(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.11,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.zero),
                                    ),
                                    child: QueryArtworkWidget(
                                      id: item.data![index].id,
                                      type: ArtworkType.AUDIO,
                                      artworkBorder: BorderRadius.circular(15).r,
                                    ),
                                  ),
                                ),
                            SizedBox(
                                  height: 15.h,
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.data![index].title,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Buttons(
                                        id: Audio.songs[index].id,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

//...... file accessing request .....//

  requestPermission() async {
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      }
      setState(() {});
    }
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
