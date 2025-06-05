/// Since Dart's inference of generics is very weak, this is the only implementation possible here.
class Result<T, E> {
  final bool isOk;

  bool get isErr => !isOk;

  final T? _data;

  T get data {
    assert(isOk);
    return _data as T;
  }

  final E? _error;

  E get error {
    assert(!isOk);
    return _error as E;
  }

  const Result.ok(T data)
      : isOk = true,
        _data = data,
        _error = null;

  const Result.err(E error)
      : isOk = false,
        _data = null,
        _error = error;

  @override
  String toString() {
    return isOk ? 'Ok($_data)' : 'Err($_error)';
  }
}
