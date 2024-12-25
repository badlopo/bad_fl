/// refer to https://doc.rust-lang.org/std/result/
sealed class Result<T, E> {
  const Result();

  factory Result.ok(T data) => Ok<T>(data) as Result<T, E>;

  factory Result.err(E error) => Err<E>(error) as Result<T, E>;
}

class Ok<T> implements Result<T, Never> {
  final T data;

  const Ok(this.data);
}

class Err<E> extends Result<Never, E> {
  final E error;

  const Err(this.error);
}
