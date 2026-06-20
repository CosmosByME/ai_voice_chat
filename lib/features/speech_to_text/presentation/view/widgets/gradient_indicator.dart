import 'package:flutter/material.dart';

class GradientIndicator extends StatefulWidget {
  final bool isUserSpeaking;
  final bool isAiTalking;

  const GradientIndicator({
    super.key,
    required this.isUserSpeaking,
    required this.isAiTalking,
  });

  @override
  State<GradientIndicator> createState() => _GradientIndicatorState();
}

class _GradientIndicatorState extends State<GradientIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Color> get _colors {
    if (widget.isAiTalking) {
      return [const Color(0xFF8E2DE2), const Color(0xFF4A00E0), const Color(0xFFAB47BC)];
    }
    if (widget.isUserSpeaking) {
      return [const Color(0xFF00BCD4), const Color(0xFF00E676), const Color(0xFF00E5FF)];
    }
    return [Colors.white12, Colors.white10, Colors.white12];
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Container(
          height: 4,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: LinearGradient(
              begin: Alignment(
                -1 + _animation.value * 0.6,
                0,
              ),
              end: Alignment(
                0.4 + _animation.value * 0.6,
                0,
              ),
              colors: _colors,
            ),
            boxShadow: (widget.isUserSpeaking || widget.isAiTalking)
                ? [
                    BoxShadow(
                      color: _colors.first.withValues(alpha: 0.5),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
        );
      },
    );
  }
}
