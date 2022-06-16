import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heal_music/screens/splash.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../playlist/db/datamodel.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Settings',
          style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  launchUrl(Uri.parse('https://vishnusankarpv.github.io/SN/'));
                },
                child: Image(
                  image: const AssetImage(
                    'lib/assets/web-removebg-preview.png',
                  ),
                  width: 100.w,
                  height: 100.h,
                )),
            const Text(
              'Website ',
              style: TextStyle(color: Colors.orange),
            ),
            SizedBox(
              height: 30.h,
            ),
            Text(
              'About',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold),
            ),
            const Divider(
              color: Colors.orange,
              indent: 50,
              endIndent: 50,
            ),
            Padding(
              padding: EdgeInsets.all(14.r),
              child: Text(
                "Thankyou for using the app its a simple ofline music player,created by sankaranarayanan using flutter",
                style: TextStyle(color: Colors.white, fontSize: 20.sp),
              ),
            ),
            Image.asset(
              'lib/assets/SPLASH11111.png',
              width: 130.w,
              height: 130.h,
            ),
            const Text(
              'Version V1.0.0',
              style: TextStyle(color: Colors.orange),
            ),
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 215, 175, 54)),
                onPressed: () {
                 
                   showDialog(
                            context: context,
                            builder: (BuildContext ctx) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                // title: const Text(
                                //     'do you want to remove the song?'),
                                content: const Text(
                                  'Do you want to reset the app?',
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
                                      
                                         clearDb();

                                  Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const Splash()
                                    ));
                                        // Navigator.of(ctx).pop();
                                      },
                                      child: const Text('Yes'))
                                ],
                              );
                            },
                          );
                },
                icon: const Icon(Icons.restore),
                label: const Text('Reset App'))
          ],
        ),
      ),
    );
  }

  void clearDb() {
    final clrFav = Hive.box('favourites');
    clrFav.clear();
    final clrPly = Hive.box<MusicModel>('playlistsongs');
    clrPly.clear();
  }
}
