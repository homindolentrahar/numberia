import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';
import 'package:simple_animations/simple_animations.dart';

enum RevealAnimationProps { OPACITY, SCALE }

class RevealAnimation extends StatelessWidget {
  final Widget child;
  final double delay;

  const RevealAnimation({
    Key key,
    @required this.child,
    @required this.delay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _tween = TimelineTween<RevealAnimationProps>()
      ..addScene(begin: 0.milliseconds, end: 700.milliseconds)
          .animate(
            RevealAnimationProps.OPACITY,
            tween: 0.0.tweenTo(1.0),
            curve: Curves.easeIn,
          )
          .animate(
            RevealAnimationProps.SCALE,
            tween: 0.0.tweenTo(1.0),
            curve: Curves.easeIn,
          );

    return PlayAnimation<TimelineValue<RevealAnimationProps>>(
      delay: (delay * 700).round().milliseconds,
      tween: _tween,
      child: child,
      builder: (ctx, child, animation) => Opacity(
        opacity: animation.get(RevealAnimationProps.OPACITY),
        child: Transform.scale(
          scale: animation.get(RevealAnimationProps.SCALE),
          child: child,
        ),
      ),
    );
  }
}
