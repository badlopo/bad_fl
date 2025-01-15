// /// refer to https://doc.rust-lang.org/std/result/
// sealed class Result<T, E> {
//   const Result();
//
//   factory Result.ok(T data) => Ok<T>(data) as Result<T, E>;
//
//   factory Result.err(E error) => Err<E>(error) as Result<T, E>;
//
//   bool isOk() => this is Ok<T>;
//
//   bool isErr() => this is Err<T>;
//
//   T unwrap() {
//     return switch (this) {
//       Ok<dynamic>() => (this as Ok<T>).data,
//       Err<dynamic>() => throw StateError('cannot apply unwrap on Err<$E>'),
//     };
//   }
// }
//
// class Ok<T> extends Result<T, Never> {
//   final T data;
//
//   const Ok(this.data);
//
//   @override
//   String toString() {
//     return data.toString();
//   }
// }
//
// class Err<E> extends Result<Never, E> {
//   final E error;
//
//   const Err(this.error);
//
//   @override
//   String toString() {
//     return error.toString();
//   }
// }

/// Since Dart's inference of generics is very weak, this is the only implementation possible here.
class Result<T, E> {
  final bool isOk;

  bool get isErr => !isOk;

  final T? _data;

  T get data {
    assert(isOk);
    return _data!;
  }

  final E? _error;

  E get error {
    assert(!isOk);
    return _error!;
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
