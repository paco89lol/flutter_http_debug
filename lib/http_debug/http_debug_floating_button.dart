import 'dart:math';

import 'package:flutter/material.dart';

import 'http_debug.dart';
import 'data/0_data.dart';
import 'screens/0_screens.dart';

/// Global Floating Button Widget with https Inspector overlay
class HttpDebugFloatingButton extends StatefulWidget {
  final HttpDebugContext httpDebugContext =
      HttpsDebug.instance.httpsDebugContext;

  HttpDebugFloatingButton({super.key});

  @override
  State<HttpDebugFloatingButton> createState() =>
      _HttpDebugFloatingButtonState();
}

class _HttpDebugFloatingButtonState
    extends State<HttpDebugFloatingButton>
    with SingleTickerProviderStateMixin {
  bool _isInspectorVisible = false;

  Offset _floatingButtonPosition = const Offset(20, 600); // Initial position

  int animatedPositionedDuration = 300;

  // A list to manage rockets for animation
  final List<_Rocket> _rockets = [];
  late AnimationController _controller;

  void toggleInspector() {
    setState(() {
      _isInspectorVisible = !_isInspectorVisible;
    });
  }

  void _adjustToSide(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    setState(() {
      // Move button to the nearest side (left or right)
      animatedPositionedDuration = 300;
      _floatingButtonPosition = Offset(
        _floatingButtonPosition.dx < screenWidth / 2 ? 20 : screenWidth - 70,
        _floatingButtonPosition.dy,
      );
    });
  }

  void _launchRocket(String text, Color color) {
    // Add a new rocket to the list
    setState(() {
      _rockets.add(
        _Rocket(
          text: text,
          color: color,
          startX: _floatingButtonPosition.dx + 20,
          startY: _floatingButtonPosition.dy + 10,
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller for continuous animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // Frame duration (~60 FPS)
    )..addListener(() {
      // Update rockets' positions on every frame
      setState(() {
        for (var rocket in _rockets) {
          rocket.updatePosition();
        }
        // Remove rockets that have moved off-screen
        _rockets.removeWhere((rocket) => rocket.isOffScreen);
      });
    });

    _controller.repeat();

    // Add a listener to the circularBufferNotifier to trigger rockets
    widget.httpDebugContext.circularBufferNotifier.addListener(__launchRocket);
  }

  @override
  void dispose() {
    _controller.dispose();
    // Remove the notifier listener
    widget.httpDebugContext.circularBufferNotifier.removeListener(__launchRocket);
    super.dispose();
  }

  void __launchRocket() {
    final responseCode = widget.httpDebugContext.circularBufferNotifier.buffer.last?.responseCode;
    var text = "";
    var color = Colors.white;
    if (responseCode != null && responseCode >= 200 && responseCode < 300 ) {
      text = '🚀';
    } else if (responseCode != null && responseCode >= 300 && responseCode < 400) {
      text = '${responseCode}';
      color = Colors.orange;
    } else if (responseCode != null && responseCode >= 400) {
      text = '${responseCode}';
      color = Colors.red;
    }
    _launchRocket(text, color);
  }

  @override
  Widget build(BuildContext context) {
    final isVisible = true; // Control floating button visibility as needed

    return Stack(
      children: [
        if (isVisible)
          AnimatedPositioned(
            duration: Duration(milliseconds: animatedPositionedDuration),
            curve: Curves.easeOut,
            left: _floatingButtonPosition.dx,
            top: _floatingButtonPosition.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  // Update the position of the button as it's dragged
                  animatedPositionedDuration = 0;
                  _floatingButtonPosition += details.delta;
                });
              },
              onPanEnd: (details) {
                // Adjust position to the nearest side when dragging ends
                _adjustToSide(context);
              },
              onTapUp: (detail) {
                toggleInspector();
              },
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.2 * 255).toInt()),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation:
                      widget.httpDebugContext.circularBufferNotifier,
                      builder: (context, _) {
                        final context = widget.httpDebugContext;
                        final buffer =context.circularBufferNotifier.buffer;
                        return Text(
                          "${buffer.length}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (isVisible)
        // CustomPaint to draw rockets, wrapped in IgnorePointer
          IgnorePointer(
            ignoring: true, // Prevent CustomPaint from intercepting events
            child: CustomPaint(
              size: Size.infinite,
              painter: _RocketPainter(_rockets),
            ),
          ),
        if (_isInspectorVisible)
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Material(
              color: Colors.white,
              child: Stack(
                children: [
                  HeroControllerScope(
                    controller: MaterialApp.createMaterialHeroController(),
                    // Create a separate HeroController
                    child: Navigator(
                      onGenerateRoute: (RouteSettings settings) {
                        return MaterialPageRoute(
                          builder:
                              (context) => HttpDebugScreen(
                                toggleInspector: toggleInspector,
                                httpDebugContext:
                                    HttpsDebug
                                        .instance
                                        .httpsDebugContext,
                              ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/*
* Rocket animation start near the floating button
*  */
class _Rocket {
  String text;
  Color color;
  double x; // Horizontal position
  double y; // Vertical position
  final double speed; // Speed of the rocket
  final double angle; // Angle of movement
  final double size; // Size of the rocket
  final double initialY; // Initial starting position
  bool isOffScreen = false;

  _Rocket({required this.text, required this.color, required double startX, required double startY})
      : x = startX,
        y = startY,
        initialY = startY,
        speed = 1.7,
  // Random speed
        angle = -pi / 2,
  // Slight variation in angle
        size = 13;

  void updatePosition() {
    // Update position based on the speed and angle
    x += speed * cos(angle);
    y += speed * sin(angle);

    // Mark the rocket as off-screen if it moves out of bounds
    if ((y < -50 || x < -50 || x > 500) || y < initialY - 100) {
      isOffScreen = true;
    }
  }
}

class _RocketPainter extends CustomPainter {
  final List<_Rocket> rockets;

  _RocketPainter(this.rockets);

  @override
  void paint(Canvas canvas, Size size) {
    for (var rocket in rockets) {
      _drawRocket(canvas, rocket);
    }
  }

  void _drawRocket(Canvas canvas, _Rocket rocket) {
    // Define the text style for the rocket emoji
    final textStyle = TextStyle(
      color: rocket.color,
      fontSize: rocket.size, // Scale the size of the emoji
      fontWeight: FontWeight.bold,
    );

    // Create a TextSpan with the 🚀 emoji
    final textSpan = TextSpan(text: rocket.text, style: textStyle);

    // Use a TextPainter to paint the emoji
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(); // Layout the text for proper sizing

    // Calculate the position to center the emoji at the rocket's coordinates
    final offset = Offset(
      rocket.x - textPainter.width / 2, // Center horizontally
      rocket.y - textPainter.height / 2, // Center vertically
    );

    // Paint the emoji on the canvas
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Always repaint for continuous animations
  }
}
