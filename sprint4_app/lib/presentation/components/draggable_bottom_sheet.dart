import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sprint4_app/presentation/pages/list_page.dart';

class DraggableBottomSheet extends StatefulWidget {
  @override
  State<DraggableBottomSheet> createState() => _DraggableBottomSheetState();
}

class _DraggableBottomSheetState extends State<DraggableBottomSheet>
    with SingleTickerProviderStateMixin {
  final double minHeight = 120;
  final double maxHeight = 800;
  
  late AnimationController _controller;
  
  double currentHeight = 120;
  bool isExpanded = false;
  bool isDragging = false;

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
    if (isExpanded) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: GestureDetector(
        onVerticalDragStart: (details) {
          isDragging = true;
        },
        onVerticalDragUpdate: (details) {
          setState(() {
            currentHeight -= details.delta.dy;
            currentHeight = currentHeight.clamp(minHeight, maxHeight);
          });
        },
        onVerticalDragEnd: (details) {
          isDragging = false;
          final threshold = 5.0; 
          if (details.primaryVelocity! < -threshold) {
            currentHeight = maxHeight;
            _controller.forward();
            setState(() {
              isExpanded = true;
            });
          } else if (details.primaryVelocity! > threshold) {
            currentHeight = minHeight;
            _controller.reverse();
            setState(() {
              isExpanded = false;
            });
          } else {
            if (isExpanded) {
              currentHeight = maxHeight;
              _controller.forward();
            } else {
             currentHeight = minHeight;
              _controller.reverse();
            }
          }
        },
        child: Container(
          height: currentHeight,
          decoration: BoxDecoration(
            color: Color(0xFF1E1E1E),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
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
                  if (currentHeight <= 200)
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
                  if (currentHeight > 200)
                    Expanded(child: ListPage(viewModel: context.read()))

                ],
              ),
            ),
        ),
    );
  }
}