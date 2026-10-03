import 'package:flutter/material.dart';

Widget buildVideoWidget(BuildContext context) {
  return const SizedBox.expand(
    child: ColoredBox(
      color: Color(0xFF42A5F5),
      child: Center(
        child: Icon(Icons.cottage_rounded, color: Colors.white, size: 48.0),
      ),
    ),
  );
}
