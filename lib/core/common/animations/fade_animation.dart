import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';
import 'package:simple_animations/simple_animations.dart';

enum FadeAnimationProps { OPACITY, TRANSLATE_Y }

enum FadeAnimationDirections { UP, DOWN, LEFT, RIGHT }

class FadeAnimation extends StatelessWidget {
  final Widget child;
  final FadeAnimationDirections direction;
  final double delay;

  const FadeAnimation({
    Key key,
    this.direction,
    this.delay,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<FadeAnimationDirections, Offset> _yTweens = {
      FadeAnimationDirections.UP: Offset(0, 200),
      FadeAnimationDirections.DOWN: Offset(0, -200),
      FadeAnimationDirections.LEFT: Offset(-200, 0),
      FadeAnimationDirections.RIGHT: Offset(200, 0),
    };

    final _tween = TimelineTween<FadeAnimationProps>()
      ..addScene(
        begin: 0.milliseconds,
        end: 700.milliseconds,
        curve: Curves.easeInSine,
      )
          .animate(
            FadeAnimationProps.OPACITY,
            tween: 0.0.tweenTo(1.0),
            curve: Curves.easeInSine,
          )
          .animate(
            FadeAnimationProps.TRANSLATE_Y,
            tween: _yTweens[direction].tweenTo(Offset.zero),
            curve: Curves.easeInSine,
          );

    return PlayAnimation<TimelineValue<FadeAnimationProps>>(
      duration: _tween.duration,
      delay: (delay * 700).round().milliseconds,
      tween: _tween,
      child: child,
      builder: (ctx, child, animation) => Opacity(
        opacity: animation.get(FadeAnimationProps.OPACITY),
        child: Transform.translate(
          offset: animation.get(FadeAnimationProps.TRANSLATE_Y),
          child: child,
        ),
      ),
    );
  }
}
