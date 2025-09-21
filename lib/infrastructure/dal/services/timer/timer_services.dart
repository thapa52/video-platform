import 'dart:async';

class TimerService {
  Timer? _timer;
  int _elapsed = 0;
  Function(int)? _onTick;

  void start({required int initial, required Function(int) onTick}) {
    _elapsed = initial;
    _onTick = onTick;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsed += 1;
      _onTick?.call(_elapsed);
    });
  }

  void stop() {
    _timer?.cancel();
  }

  void dispose() {
    _timer?.cancel();
  }
}
