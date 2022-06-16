import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heal_music/favouries/button.dart';
import 'package:heal_music/favouries/dbfunctions/function.dart';
import 'package:heal_music/screens/audio.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart';

class Playing extends StatefulWidget {
  Playing({Key? key, required this.loopsong}) : super(key: key);

  static int currentindex = 0;
  List<SongModel> loopsong = [];

  static List<SongModel> minilist = [];
  @override
  State<Playing> createState() => _PlayingState();
}

class _PlayingState extends State<Playing> {
  bool shuffleCheck = false;

  // ...... duration state of progress bar ........//

  Stream<DurationState> get _durationStateStream =>
      Rx.combineLatest2<Duration, Duration?, DurationState>(
          Audio.paattu.positionStream,
          Audio.paattu.durationStream,
          (position, duration) => DurationState(
              position: position, total: duration ?? Duration.zero));

  @override
  void initState() {
    super.initState();
    Playing.minilist.clear();
    for (int i = 0; i < widget.loopsong.length; i++) {
      Playing.minilist.add(widget.loopsong[i]);
    }
    Playing.minilist.addAll(widget.loopsong);

    DbFav.favourites;
    Audio.paattu.currentIndexStream.listen((index) {
      if (index != null) {
        _updateCurrentplayingSong(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
              size: 40.sp,
            )),
        title: const Text(
          'Now Playing',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // swiping next & previous
            GestureDetector(
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
              child: QueryArtworkWidget(
                  artworkHeight: 250.h,
                  artworkWidth: 250.w,
                  id: widget.loopsong[Audio.paattu.currentIndex!].id,
                  type: ArtworkType.AUDIO),
            ),

            Text(
              widget.loopsong[Audio.paattu.currentIndex!].title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 20.sp, color: Colors.white),
            ),
            Text(
              widget.loopsong[Audio.paattu.currentIndex!].artist.toString(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16.sp, color: Colors.white),
            ),

            //<<......shuffle,favourite,repeate buttons.......>>//

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: InkWell(onTap: () {
                    if (shuffleCheck == false) {
                      Audio.paattu.setShuffleModeEnabled(true);
                      shuffleCheck = true;
                      setState(() {});
                    } else {
                      Audio.paattu.setShuffleModeEnabled(false);
                      shuffleCheck = false;
                      setState(() {});
                    }
                  }, child: Builder(builder: ((context) {
                    if (shuffleCheck == false) {
                      return Icon(
                        Icons.shuffle,
                        color: Colors.white,
                        size: 20.sp,
                      );
                    } else {
                      return Icon(
                        Icons.shuffle,
                        color: Colors.red,
                        size: 20.sp,
                      );
                    }
                  }))),
                ),
                Buttons(id: widget.loopsong[Playing.currentindex].id),
                Flexible(
                  child: InkWell(
                      onTap: () {
                        Audio.paattu.loopMode == LoopMode.one
                            ? Audio.paattu.setLoopMode(LoopMode.all)
                            : Audio.paattu.setLoopMode(LoopMode.one);
                      },
                      child: StreamBuilder<LoopMode>(
                        stream: Audio.paattu.loopModeStream,
                        builder: (context, snapshot) {
                          final loopMode = snapshot.data;
                          if (LoopMode.one == loopMode) {
                            return Icon(
                              Icons.repeat_one,
                              color: Colors.red,
                              size: 20.sp,
                            );
                          } else {
                            return Icon(
                              Icons.repeat,
                              color: Colors.white,
                              size: 20.sp,
                            );
                          }
                        },
                      )),
                )
              ],
            ),

            Column(
              children: [
                //slider bar container
                Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10).r,
                  child: StreamBuilder<DurationState>(
                    stream: _durationStateStream,
                    builder: (context, snapshot) {
                      final durationState = snapshot.data;
                      final progress = durationState?.position ?? Duration.zero;
                      final total = durationState?.total ?? Duration.zero;

                      return ProgressBar(
                        progress: progress,
                        total: total,
                        barHeight: 2.0,
                        baseBarColor: Colors.grey,
                        thumbRadius: 7,
                        progressBarColor:
                            const Color.fromARGB(237, 190, 52, 52),
                        thumbColor:
                            const Color.fromARGB(255, 255, 0, 0).withBlue(49),
                        timeLabelTextStyle: TextStyle(
                          fontSize: 15.sp,
                        ),
                        onSeek: (duration) {
                          Audio.paattu.seek(duration);
                        },
                      );
                    },
                  ),
                ),

                SizedBox(
                  height: 30.h,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                        child: InkWell(
                      onTap: () {
                        if (Audio.paattu.hasPrevious) {
                          Audio.paattu.seekToPrevious();
                        }
                      },
                      child: CircleAvatar(
                        backgroundImage: const AssetImage(
                            'lib/assets/269-2695611_blur-gradient-background-hd.jpg'),
                        child: Icon(
                          Icons.skip_previous,
                          color: Colors.black,
                          size: 25.sp,
                        ),
                      ),
                    )),
                    Flexible(
                        child: InkWell(
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
                            return CircleAvatar(
                              backgroundImage: const AssetImage(
                                  'lib/assets/269-2695611_blur-gradient-background-hd.jpg'),
                              radius: 30,
                              child: Icon(
                                Icons.pause,
                                size: 40.sp,
                                color: Colors.black,
                              ),
                            );
                          }
                          return CircleAvatar(
                            backgroundImage: const AssetImage(
                                'lib/assets/269-2695611_blur-gradient-background-hd.jpg'),
                            radius: 30,
                            child: Icon(
                              Icons.play_arrow,
                              size: 40.sp,
                              color: Colors.black,
                            ),
                          );
                        },
                      ),
                    )),
                    Flexible(
                        child: InkWell(
                      onTap: () async {
                        if (Audio.paattu.hasNext) {
                          await Audio.paattu.seekToNext();
                        }
                      },
                      child: CircleAvatar(
                        backgroundImage: const AssetImage(
                            'lib/assets/269-2695611_blur-gradient-background-hd.jpg'),
                        child: Icon(
                          Icons.skip_next,
                          color: Colors.black,
                          size: 25.sp,
                        ),
                      ),
                    )),
                  ],
                ),

                SizedBox(
                  height: 70.sp,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  _updateCurrentplayingSong(index) {
    setState(() {
      if (Audio.paattu.currentIndex != null) {
        Playing.currentindex = index;
      }
    });
  }
}

class DurationState {
  DurationState({this.position = Duration.zero, this.total = Duration.zero});
  Duration position, total;
}
