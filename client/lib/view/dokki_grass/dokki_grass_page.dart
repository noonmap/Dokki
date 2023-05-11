import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class DokkiGrassPage extends StatelessWidget {
  const DokkiGrassPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ModelViewer(src: "assets/3d/RockWalkway01.glb");
  }
}
