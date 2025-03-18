class CircularBuffer<T> {
  final int maxSize;
  final List<T?> _buffer = [];
  int _start = 0;
  int _count = 0;

  CircularBuffer({required this.maxSize});

  void add(T item) {
    if (_count < maxSize) {
      _buffer.add(item);
      _count++;
    } else {
      _buffer[_start] = item;
      _start = (_start + 1) % maxSize; // Overwrite the oldest element
    }
  }

  List<T> toList() {
    return List.generate(_count, (i) => _buffer[(_start + i) % maxSize]!);
  }

  bool get isEmpty => _buffer.isEmpty;

  bool get isNotEmpty => _buffer.isNotEmpty;

  int get length => _buffer.length;

  T? get last => _buffer.last;

  void clear() {
    _buffer.clear();
    _start = 0;
    _count = 0;
  }

}