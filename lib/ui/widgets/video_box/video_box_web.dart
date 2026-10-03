// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';

bool _viewRegistered = false;
const String _viewId = 'brickup-logo-video-view';

Widget buildVideoWidget(BuildContext context) {
  if (!_viewRegistered) {
    ui_web.platformViewRegistry.registerViewFactory(_viewId, (int viewId) {
      final video = html.VideoElement()
        ..autoplay = true
        ..loop = true
        ..muted = true
        ..controls = false
        ..setAttribute('playsinline', 'true')
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.objectFit = 'cover'
        ..style.display = 'block'
        ..style.border = 'none'
        ..style.outline = 'none'
        ..style.margin = '0'
        ..style.padding = '0';

      final source1 = html.SourceElement()
        ..src = 'assets/videos/logo.mp4'
        ..type = 'video/mp4';
      video.append(source1);

      final source2 = html.SourceElement()
        ..src = 'assets/assets/videos/logo.mp4'
        ..type = 'video/mp4';
      video.append(source2);

      video.src = 'assets/videos/logo.mp4';

      return video;
    });
    _viewRegistered = true;
  }

  return const SizedBox.expand(
    child: HtmlElementView(viewType: _viewId),
  );
}
