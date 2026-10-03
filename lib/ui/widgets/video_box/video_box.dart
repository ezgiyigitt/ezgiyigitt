import 'package:flutter/material.dart';
import 'video_box_stub.dart'
    if (dart.library.js_interop) 'video_box_web.dart';

class VideoBox extends StatelessWidget {
  const VideoBox({super.key});

  @override
  Widget build(BuildContext context) {
    return buildVideoWidget(context);
  }
}
