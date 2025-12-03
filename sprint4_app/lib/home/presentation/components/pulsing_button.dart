import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PulsingButton extends StatefulWidget {
  final VoidCallback? onTap;

  const PulsingButton({super.key, this.onTap});

  @override
  State<PulsingButton> createState() => _PulsingButtonState();
}

class _PulsingButtonState extends State<PulsingButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    final isTesting = context.read<bool>();
    final int duration = isTesting ? 0 : 1500;

    _controller = AnimationController(
      duration: Duration(milliseconds: duration),
      vsync: this
    );

    if (!isTesting) {
      _controller.repeat(reverse: true);
    }

    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Center(
        child: ScaleTransition(
          scale: _animation,
          child: SizedBox(
            width: 250,
            child: Image.asset(
              'assets/images/pic-button.png',
              excludeFromSemantics: true,
            ),
          ),
        ),
      ),
    );
  }
}