import 'dart:async'; // For Timer

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart'; // For frame callbacks

class FPSCounter with ChangeNotifier {

  static final _instance = FPSCounter._();
  static FPSCounter get instance => _instance;

  int _frameCount = 0; // Count of frames within the timer interval
  double _fps = 0; // Calculated FPS
  late Timer _timer; // Timer to control when FPS is calculated

  String _s_fps = '';
  String get value => _s_fps;

  FPSCounter._() {
    if (kDebugMode) {
      print("FPSCounter: startTracking");
    }
    startTracking();
  }

  factory FPSCounter() {
    return _instance; // Always return the same instance
  }

  /*
  * 1 second: _timeWindow = 1000
  * 1/2 second: _timeWindow = 500
  * 1/4 second: _timeWindow = 250
  * */
  // Start tracking FPS
  void startTracking({Duration interval = const Duration(milliseconds: 250)}) {
    // Start a repeating timer to calculate FPS
    _timer = Timer.periodic(interval, (timer) {
      // Calculate FPS
      // FPS = frames / seconds
      _fps = _frameCount / (interval.inMilliseconds / 1000.0);
      _s_fps = _fps.toStringAsFixed(0);
      // Reset frame counter for the next interval
      _frameCount = 0;
      notifyListeners();
    });

    // Start counting frames
    SchedulerBinding.instance.addPostFrameCallback(_trackFrames);
  }

  // Stop tracking FPS
  void stopTracking() {
    _timer.cancel(); // Cancel the timer
  }

  // Frame callback to increment frame count
  void _trackFrames(Duration timeStamp) {
    // Increment frame count
    _frameCount++;
    // Schedule the next frame callback
    SchedulerBinding.instance.addPostFrameCallback(_trackFrames);
  }
}