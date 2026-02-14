import 'package:flutter/material.dart';

enum PoseType {
  breath,
  catCow,
  child,
  downDog,
  forwardFold,
  kneesToChest,
  twist,
  plank,
  seatedStretch,
  openChest,
  relax,
}

class Exercise {
  final String id;
  final String title;
  final String description;
  final int duration;
  final String image;
  final IconData icon;
  final PoseType pose;
  final List<String> steps;

  const Exercise({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.image,
    required this.icon,
    required this.pose,
    required this.steps,
  });
}
