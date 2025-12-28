import 'package:flutter/material.dart';

class AnimatedInt extends StatelessWidget {
  final int value;
  final TextStyle? style;
  final Duration duration;

  const AnimatedInt({
    super.key,
    required this.value,
    this.style,
    this.duration = const Duration(milliseconds: 450),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.toDouble()),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (_, v, __) => Text(v.round().toString(), style: style),
    );
  }
}
