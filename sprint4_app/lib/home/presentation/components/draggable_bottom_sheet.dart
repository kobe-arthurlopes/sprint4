import 'package:flutter/material.dart';

class DraggableBottomSheet extends StatefulWidget {
  final Widget expandedContent;

  const DraggableBottomSheet({super.key, required this.expandedContent});

  @override
  State<DraggableBottomSheet> createState() => _DraggableBottomSheetState();
}

class _DraggableBottomSheetState extends State<DraggableBottomSheet>
    with SingleTickerProviderStateMixin {
  final double _minHeight = 120;
  final double _maxHeight = 800;

  late AnimationController _controller;
  late Animation<double> _heightAnimation;

  bool get _isExpanded => _controller.value > 0.5;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _heightAnimation = Tween<double>(
      begin: _minHeight,
      end: _maxHeight,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleSheet() {
    if (_isExpanded) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    final delta = details.primaryDelta;

    if (delta == null) return;

    final newValue = _controller.value - (delta / (_maxHeight - _minHeight));
    _controller.value = newValue.clamp(0, 1);
  }

  void _handleDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;

    if (velocity < -200) {
      _controller.forward();
    } else if (velocity > 200) {
      _controller.reverse();
    } else {
      if (_controller.value > 0.5) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, _) {
        final height = _heightAnimation.value;
    
        return GestureDetector(
          onVerticalDragUpdate: _handleDragUpdate,
          onVerticalDragEnd: _handleDragEnd,
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: Color(0xFF1E1E1E),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 20,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Handle (barra de arrasto)
                GestureDetector(
                  onTap: _toggleSheet,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[600],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
    
                if (height <= 200) _buildCompactView(),
    
                if (height > 200) Expanded(child: widget.expandedContent),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompactView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.photo_library, color: Colors.white),
          ),

          SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My registers',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  'Swipe up',
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
              ],
            ),
          ),

          IconButton(
            key: const Key('playIconButton'),
            onPressed: _toggleSheet,
            icon: Icon(Icons.play_arrow, color: Colors.white, size: 32),
          ),
        ],
      ),
    );
  }
}
