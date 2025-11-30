import 'package:flutter/material.dart';

class DraggableBottomSheet extends StatefulWidget {
  final Widget expandedContent;

  const DraggableBottomSheet({
    super.key, 
    required this.expandedContent,
  });

  @override
  State<DraggableBottomSheet> createState() => _DraggableBottomSheetState();
}

class _DraggableBottomSheetState extends State<DraggableBottomSheet>
    with SingleTickerProviderStateMixin {
  final double _minHeight = 120;
  final double _maxHeight = 800;
  double _currentHeight = 120;
  bool _isExpanded = false;
  
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
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

    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _currentHeight -= details.delta.dy;
      _currentHeight = _currentHeight.clamp(_minHeight, _maxHeight);
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    final threshold = 5.0;
    final primaryVelocity = details.primaryVelocity;

    if (primaryVelocity == null) return;

    if (primaryVelocity < -threshold) {
      _currentHeight = _maxHeight;
      _controller.forward();
      setState(() {
        _isExpanded = true;
      });
    } else if (primaryVelocity > threshold) {
      _currentHeight = _minHeight;
      _controller.reverse();
      setState(() {
        _isExpanded = false;
      });
    } else {
      if (_isExpanded) {
        _currentHeight = _maxHeight;
        _controller.forward();
      } else {
        _currentHeight = _minHeight;
        _controller.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: GestureDetector(
        onVerticalDragUpdate: _handleDragUpdate,
        onVerticalDragEnd: _handleDragEnd,
        child: Container(
          height: _currentHeight,
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
          child:
            Column(
              children: [
                // Handle (barra de arrasto)
                GestureDetector(
                  onTap: _toggleSheet,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16),
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
                  
                // Conteúdo minimizado
                if (_currentHeight <= 200)
                  Padding(
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
                          child: 
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Meus registros',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              Text(
                                'Arraste para cima',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Icon(Icons.play_arrow, color: Colors.white, size: 32),
                      ],
                    ),
                  ),
                  
                  // Conteúdo adicional (expandido)
                  if (_currentHeight > 200)
                    Expanded(child: widget.expandedContent)
                ],
              ),
            ),
        ),
    );
  }
}