import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heal_music/favouries/dbfunctions/function.dart';
import 'package:heal_music/playlist/db/datamodel.dart';
import 'package:heal_music/screens/splash.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio_background/just_audio_background.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // screenRotation off//
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(MusicModelAdapter().typeId)) {
    Hive.registerAdapter(MusicModelAdapter());
  }
  DbFav.getAllsongs();

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360,718),
      builder: (context, child) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.orange,
            ),
            home: const Splash());
      },
      
    );
  }
}
