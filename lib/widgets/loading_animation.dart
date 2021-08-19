import 'package:flutter/material.dart';
import 'dart:math' as math;

class LoadingAnimation extends StatefulWidget {

  final double width;

  LoadingAnimation({required this.width}) : super();

  _LoadingAnimationState createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation> with TickerProviderStateMixin{
  late final AnimationController _controller;
  late final AnimationController _controller1;
  late final AnimationController _controller2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1))..repeat();
    _controller1 = AnimationController(vsync: this, duration: Duration(seconds: 2))..repeat();
    _controller2 = AnimationController(vsync: this, duration: Duration(seconds: 3))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child:
        Stack(alignment: Alignment.center, children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (_, child) {
              return Transform.rotate(
                angle: _controller.value * 2 * math.pi,
                child: child,
              );
            },
            child: Image.asset("assets/img/loadingcircle/inner.png",width: widget.width-40)
          ),

          AnimatedBuilder(
            animation: _controller1,
            builder: (_, child) {
              return Transform.rotate(
                angle: _controller1.value * 2 * math.pi,
                child: child,
              );
            },
            child: Image.asset("assets/img/loadingcircle/center.png",width: widget.width-20)
          ),

          AnimatedBuilder(
              animation: _controller2,
              builder: (_, child) {
                return Transform.rotate(
                  angle: _controller2.value * 2 * math.pi,
                  child: child,
                );
              },
              child: Image.asset("assets/img/loadingcircle/outer.png",width: widget.width)
          ),
        ],)
    );
  }
}
