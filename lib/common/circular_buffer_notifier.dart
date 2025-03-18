import 'package:flutter/material.dart';

import 'circular_buffer.dart';


class CircularBufferNotifier<T> extends ChangeNotifier {
  final CircularBuffer<T> _buffer;
  final int maxLength;
  CircularBufferNotifier({required this.maxLength})
      : _buffer = CircularBuffer<T>(maxSize: maxLength);

  CircularBuffer<T> get buffer => _buffer;


  void clear() {
    _buffer.clear();
    notifyListeners(); // Notify listeners after clearing
  }

  void add(T item) {
    _buffer.add(item);
    notifyListeners(); // Notify listeners after adding
  }

}