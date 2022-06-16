import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'audio.dart';
import 'now_playing.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({Key? key}) : super(key: key);

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  @override
  void initState() {
    Audio.paattu.currentIndexStream.listen((event) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: ColoredBox(
          color: Colors.white.withOpacity(0.5),
          child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                  int sensitivity = 0;
                  if (details.delta.dx > sensitivity) {
                    if (Audio.paattu.hasPrevious) {
                      Audio.paattu.seekToPrevious();
                    }
                    // Right Swipe
                  } else if (details.delta.dx < -sensitivity) {
                    if (Audio.paattu.hasNext) {
                      Audio.paattu.seekToNext();
                    }
                    //Left Swipe
                  }
                },
            child: ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Playing(loopsong: Audio.songs)));
              },
              leading: QueryArtworkWidget(
                  // artworkHeight: 250,
                  // artworkWidth: 250,
                  id: Playing.minilist[Audio.paattu.currentIndex!].id,
                  type: ArtworkType.AUDIO),
              title: Text(
                Playing.minilist[Audio.paattu.currentIndex!].title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: InkWell(
                onTap: () {
                  if (Audio.paattu.playing) {
                    Audio.paattu.pause();
                  } else {
                    if (Audio.paattu.currentIndex != null) {
                      Audio.paattu.play();
                    }
                  }
                },
                child: StreamBuilder<bool>(
                  stream: Audio.paattu.playingStream,
                  builder: (context, snapshot) {
                    bool? playingState = snapshot.data;
                    if (playingState != null && playingState) {
                      return Icon(
                        Icons.pause,
                        size: 40.sp,
                        color: Colors.black,
                      );
                    }
                    return Icon(
                      Icons.play_arrow,
                      size: 40.sp,
                      color: Colors.black,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
