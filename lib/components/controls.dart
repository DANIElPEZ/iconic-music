import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:iconicmusic/utils/audio_handler.dart';

class Controls extends StatefulWidget {
  Controls({required this.file_url, required this.artist, required this.title, required this.audioHandler, required this.image_url});

  final String file_url, title, artist, image_url;
  final AudioHandler audioHandler;

  @override
  State<StatefulWidget> createState() => ControlsState();
}

class ControlsState extends State<Controls> {
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    initializeAudioHandler();
  }

  Future<void> initializeAudioHandler() async {
    try {
      await (widget.audioHandler as audioHandler).playSingleTrack(widget.file_url, widget.title, widget.artist, widget.image_url);

      widget.audioHandler.mediaItem.listen((mediaItem) {
          setState(() {
            duration = mediaItem?.duration ?? Duration.zero;
          });
        },
        onError: handleError
      );

      widget.audioHandler.playbackState.listen((state) {
          setState(() {
            position = state.position;
            isLoading = state.processingState == AudioProcessingState.loading;
          });
      },
      onError: handleError);

        setState(() {
          isLoading = false;
          errorMessage=null;
        });
    }catch(e){
      handleError(e);
    }
  }

  void handleError(dynamic error) {
      setState(() {
        isLoading = false;
        errorMessage = error.toString();
      });
    print('Audio error: $error');
  }

  String formatTime(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> seekRelative(int seconds) async {
    final newPosition = position.inSeconds + seconds;
    if (newPosition < 0) {
      await widget.audioHandler.seek(Duration.zero);
    } else if (newPosition > duration.inSeconds) {
      await widget.audioHandler.seek(duration);
    } else {
      await widget.audioHandler.seek(Duration(seconds: newPosition));
    }
  }

  @override
  Widget build(BuildContext context) {

    if(isLoading){
      return Column(children: [
        SliderTheme(
            data: SliderTheme.of(context).copyWith(
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 9)),
            child: Slider(
                min: 0,
                max: 0,
                value: 0,
                activeColor: Colors.white,
                inactiveColor: Colors.white30,
                onChanged: (_) {})),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('00:00',
                  style: TextStyle(color: Colors.white, fontSize: 12)),
              Text('00:00',
                  style: TextStyle(color: Colors.white, fontSize: 12))
            ]
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.replay_5, color: Colors.white, size: 35)),
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.play_arrow, color: Colors.white, size: 37)),
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.forward_5, color: Colors.white, size: 35))
        ])
      ]);
    }

    return
      Column(children: [
        SliderTheme(
            data: SliderTheme.of(context).copyWith(
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 9)),
            child: Slider(
                min: 0,
                max: duration.inSeconds.toDouble(),
                value: duration.inSeconds > 0
                    ? position.inSeconds
                    .toDouble()
                    .clamp(0, duration.inSeconds.toDouble())
                    : 0,
                activeColor: Colors.white,
                inactiveColor: Colors.white30,
                onChanged: (value) async {
                  await widget.audioHandler.seek(Duration(seconds: value.toInt()));
                })),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(formatTime(position),
                style: TextStyle(color: Colors.white, fontSize: 12)),
            Text(formatTime(duration),
                style: TextStyle(color: Colors.white, fontSize: 12))
          ]
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          IconButton(
              onPressed: () => seekRelative(-5),
              icon: Icon(Icons.replay_5, color: Colors.white, size: 35)),
          StreamBuilder<PlaybackState>(
              stream: widget.audioHandler.playbackState,
              builder: (context, snapshot) {
                final playing = snapshot.data?.playing ?? false;
                return IconButton(
                    onPressed: () async{
                      if(playing){
                        await widget.audioHandler.pause();
                      }else{
                        await widget.audioHandler.play();
                      }
                    },
                    icon: Icon(playing ? Icons.pause : Icons.play_arrow,
                        color: Colors.white, size: 37));
              }),
          IconButton(
              onPressed: () =>seekRelative(5),
              icon: Icon(Icons.forward_5, color: Colors.white, size: 35))
        ])
      ]);
  }

}