import 'dart:async';

import 'package:dio/dio.dart';

/// trait bound for response wrapper,
/// extend this class to implement your own response wrapper
abstract class FromResponse<T> {
  T? get data;

  bool get ok;
}

/// wrapper for request
class FromRequest<Resp extends FromResponse> {
  final Future<Resp> resp;
  final CancelToken? _cancelToken;

  bool get cancelable => _cancelToken != null;

  void cancel() {
    _cancelToken?.cancel();
  }

  FromRequest({required this.resp, required CancelToken? cancelToken})
      : _cancelToken = cancelToken;
}

class BadRequester<Context, Resp extends FromResponse> {
  final String baseUrl;

  final Map<String, dynamic> Function(Context?)? headerBuilder;
  final Object? Function(dynamic data, Context? context)? bodyBuilder;
  final Resp Function(Response response, Context? context) responseHandler;

  BadRequester({
    required this.baseUrl,
    this.headerBuilder,
    this.bodyBuilder,
    required this.responseHandler,
  });

  FromRequest<Resp> request(
    String method,
    String path, {
    bool cancelable = false,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Context? context,
  }) {
    final BaseOptions options = BaseOptions(
      method: method,
      baseUrl: baseUrl,
      headers: headerBuilder?.call(context),
    );
    final CancelToken? cancelToken = cancelable ? CancelToken() : null;
    final Dio instance = Dio(options);
    if (bodyBuilder != null) data = bodyBuilder!(data, context);

    return FromRequest(
      resp: Future(() async {
        final Response response = await instance.request(
          path,
          data: data,
          queryParameters: queryParameters,
          cancelToken: cancelToken,
        );

        return responseHandler(response, context);
      }),
      cancelToken: cancelToken,
    );
  }
}

class MyResp extends FromResponse {
  final dynamic _data;

  @override
  // TODO: implement data
  get data => _data;

  @override
  // TODO: implement ok
  bool get ok => _data != null;

  MyResp(this._data);
}

// unit test
void main() async {
  final requester = BadRequester(
    baseUrl: 'https://jsonplaceholder.typicode.com',
    responseHandler: (Response<dynamic> response, context) {
      if (response.statusCode != 200) return MyResp(null);
      return MyResp(response.data);
    },
  );

  final r = await requester.request('get', '/todos/1').resp;

  print(r.ok);
  print(r.data);
}
