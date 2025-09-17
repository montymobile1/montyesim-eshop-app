import "dart:async";

class ValueStream<T> {
  final StreamController<T> _controller = StreamController<T>.broadcast();
  T? _currentValue;
  
  Stream<T> get stream => _controller.stream;
  T? get currentValue => _currentValue;
  bool get hasValue => _currentValue != null;
  
  void add(T value) {
    _currentValue = value;
    _controller.add(value);
  }
  
  Future<void> dispose() async {
    await _controller.close();
  }
}
