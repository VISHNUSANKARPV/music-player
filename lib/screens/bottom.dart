// import 'package:flutter/material.dart';
// import 'package:heal_music/favourite.dart';
// import 'package:heal_music/home.dart';
// import 'package:heal_music/playlist.dart';
// import 'package:heal_music/search.dart';
// import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
// import 'package:heal_music/settings.dart';

// class Bottom extends StatefulWidget {
//   const Bottom({Key? key}) : super(key: key);

//   @override
//   State<Bottom> createState() => _BottomState();
// }

// class _BottomState extends State<Bottom> {
//   List<Widget> screens = const [
//     Home(),
//     Search(),
//     Favourite(),
//     PlayList(),
//     Settings()
//   ];

//   int _selectedIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: screens[_selectedIndex],
//       bottomNavigationBar: FlashyTabBar(
//         backgroundColor: Colors.black,
//         selectedIndex: _selectedIndex,
//         showElevation: true,
//         onItemSelected: (index) => setState(() {
//           _selectedIndex = index;
//         }),
//         items: [
//           FlashyTabBarItem(
//             icon: const Icon(
//               Icons.home,
//               color: Colors.white,
//               size: 22,
//             ),
//             title: const Text('Home', style: TextStyle(color: Colors.green)),
//           ),
//           FlashyTabBarItem(
//             icon: const Icon(
//               Icons.search,
//               color: Colors.white,
//               size: 22,
//             ),
//             title: const Text('Search', style: TextStyle(color: Colors.blue)),
//           ),
//           FlashyTabBarItem(
//             icon: const Icon(
//               Icons.favorite,
//               color: Colors.white,
//               size: 22,
//             ),
//             title: const Text('Favourite', style: TextStyle(color: Colors.red)),
//           ),
//           FlashyTabBarItem(
//             icon: const Icon(
//               Icons.library_music,
//               color: Colors.white,
//               size: 21,
//             ),
//             title: const Text(
//               'Playlist',
//               style: TextStyle(color: Colors.grey),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
