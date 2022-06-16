import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:heal_music/favouries/favourite.dart';
import 'package:heal_music/screens/audio.dart';
import 'package:heal_music/screens/home.dart';
import 'package:heal_music/playlist/playlist.dart';
import 'package:heal_music/screens/miniplayer.dart';
import 'package:heal_music/screens/search.dart';
import 'package:heal_music/screens/settings.dart';

class Bottum extends StatefulWidget {
  const Bottum({Key? key}) : super(key: key);

  @override
  State<Bottum> createState() => _BottumState();
}

class _BottumState extends State<Bottum> {
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  int index = 2;

  final screens = [
    const Search(),
    const Favourite(),
    const Home(),
    PlayList(),
    const Settings()
  ];
  final items = <Widget>[
    const Icon(
      Icons.search,
      size: 20,
      color: Color.fromARGB(255, 0, 0, 0),
    ),
    const Icon(
      Icons.favorite_border_outlined,
      size: 20,
      color: Color.fromARGB(255, 0, 0, 0),
    ),
    const Icon(
      Icons.home,
      size: 30,
      color: Color.fromARGB(255, 0, 0, 0),
    ),
    const Icon(
      Icons.playlist_add,
      size: 20,
      color: Color.fromARGB(255, 0, 0, 0),
    ),
    const Icon(
      Icons.settings,
      size: 20,
      color: Color.fromARGB(255, 0, 0, 0),
    ),
  ];
  @override
  void initState() {
    Audio.paattu.currentIndexStream.listen((event) {
 
        setState(() {});
     
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: screens[index],
      bottomNavigationBar: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Audio.paattu.currentIndex != null || Audio.paattu.playing
              ? const MiniPlayer()
              : const SizedBox(),
          CurvedNavigationBar(
            key: navigationKey,
            color: const Color.fromARGB(255, 255, 255, 255),
            buttonBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
            backgroundColor: Colors.transparent,
            animationCurve: Curves.easeInOut,
            animationDuration: const Duration(milliseconds: 500),
            height: 50,
            index: index,
            items: items,
            onTap: (index) => setState(() => this.index = index),
          ),
        ],
      ),
    );
  }
}
