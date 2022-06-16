import 'package:flutter/material.dart';
import 'package:heal_music/playlist/db/datamodel.dart';
import 'package:heal_music/playlist/db/function.dart';
import 'package:heal_music/playlist/music_list.dart';

class PlayList extends StatelessWidget {
  PlayList({Key? key}) : super(key: key);

  final foldernamecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    PlaylistFunctions.getPlaylist();
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
              'Playlist',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
            actions: [
              IconButton(
                  onPressed: ()  {
                    showDialog(
                      context: context,
                      builder: (BuildContext ctx) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          actions: [
                            TextField(
                              controller: foldernamecontroller,
                              decoration: const InputDecoration(
                                  hintText: 'Create new playlist'),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                    child: const Text('Cancel')),
                                TextButton(
                                    onPressed: () {
                                      if (foldernamecontroller
                                          .text.isNotEmpty) {
                                        final folder =
                                            foldernamecontroller.text;

                                        final model = MusicModel(
                                            name: folder, songlistdb: []);

                                        PlaylistFunctions.addPlalist(
                                            model: model);

                                        Navigator.of(ctx).pop();
                                      }
                                    },
                                    child: const Text('Yes'))
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.create_new_folder,
                    color: Colors.white,
                  )),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ValueListenableBuilder(
              valueListenable: PlaylistFunctions.playlistsongs,
              builder:
                  (BuildContext context, List<dynamic> value, Widget? child) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 140,
                      mainAxisExtent: 110,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  itemCount: value.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.orange),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            color: Colors.white.withOpacity(0.4)),
                        child: Center(
                            child: Text(
                          value[index].name.toString(),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: ((ctx) => MusicList(
                                  folderindex: index,
                                ))));
                      },
                      onLongPress: () {
                        // PlaylistFunctions.deletplaylist(index);
                        showDialog(
                          context: context,
                          builder: (BuildContext ctx) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              // title: const Text(
                              //     'do you want to remove the song?'),
                              content: const Text(
                                'Do you want to delete the playlist',
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
                                      PlaylistFunctions.deletplaylist(index);
                                      const snackBar = SnackBar(
                                          content: Text('playlist deleted'));
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
                    );
                  },
                );
              },
            ),
          ),
        ));
  }
}
