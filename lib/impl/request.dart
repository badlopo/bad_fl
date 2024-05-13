import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

/// customized data that will be passed through.
typedef PassThrough = dynamic;

/// header builder that will be used to build headers for request.
typedef HeaderBuilder = Map<String, dynamic> Function(PassThrough passThrough);

/// data builder that will be used to build data before request.
typedef DataBuilder<T> = Function(dynamic data, PassThrough passThrough);

/// data parser that will be used to parse data from response.
typedef DataParser<T> = T Function(dynamic data, PassThrough passThrough);

/// wrapper for response
class ResponseWrapper<T> {
  final int? statusCode;
  final String? statusMessage;

  final String? globalId;
  final int? code;
  final String? msg;
  final int? pageNo;
  final int? pageSize;
  final int? pageTotal;

  /// the data from response or the result of `dataParser` if provided
  final T? data;

  bool get ok => code == 200;

  /// internal constructor
  const ResponseWrapper._({
    this.statusCode = 200,
    this.statusMessage,
    this.globalId,
    this.code,
    this.msg,
    this.pageNo,
    this.pageSize,
    this.pageTotal,
    this.data,
  });

  /// error builder
  static Future<ResponseWrapper<Never>> error([String msg = 'Network Error']) {
    return Future.value(ResponseWrapper._(msg: msg));
  }

  /// raw builder
  static ResponseWrapper<T> raw<T>(
    Response response,
    DataParser<T>? dataParser,
    dynamic passThrough,
  ) {
    // network error
    if (response.statusCode != 200) {
      return ResponseWrapper<T>._(
        statusCode: response.statusCode,
        statusMessage: response.statusMessage,
      );
    }

    var data = response.data;
    if (dataParser != null) {
      data = dataParser(data, passThrough);
    }

    return ResponseWrapper<T>._(
      // mark as ok
      code: 200,
      data: data,
    );
  }

  static ResponseWrapper<T> fromResponse<T>(
    Response response,
    DataParser<T>? dataParser,
    dynamic passThrough,
  ) {
    // network error
    if (response.statusCode != 200) {
      return ResponseWrapper<T>._(
        statusCode: response.statusCode,
        statusMessage: response.statusMessage,
      );
    }

    // direct return if not map
    if (response.data is! Map) {
      return ResponseWrapper<T>._(
        // mark as ok
        code: 200,
        data: response.data,
      );
    }

    Map<String, dynamic> data = response.data;
    // code not 200
    if (data['code'] != 200) {
      return ResponseWrapper<T>._(
        globalId: data['globalId'],
        code: data['code'],
        msg: data['msg'],
      );
    }

    // raw data
    final raw = data['data'];
    // no data
    if (raw == null) {
      return ResponseWrapper<T>._(
        globalId: data['globalId'],
        code: data['code'],
        msg: data['msg'],
        pageNo: data['pageNo'],
        pageSize: data['pageSize'],
        pageTotal: data['pageTotal'],
        data: null,
      );
    }

    // parse data and wrap
    return ResponseWrapper<T>._(
      globalId: data['globalId'],
      code: data['code'],
      msg: data['msg'],
      pageNo: data['pageNo'],
      pageSize: data['pageSize'],
      pageTotal: data['pageTotal'],
      data: dataParser == null ? raw : dataParser(raw, passThrough),
    );
  }

  Map<String, dynamic> toJson() {
    return ok
        ? {
            'globalId': globalId,
            'code': code,
            'pageNo': pageNo,
            'pageSize': pageSize,
            'pageTotal': pageTotal,
            'data': data,
          }
        : {
            'globalId': globalId,
            'code': code,
            'msg': msg,
            'statusCode': statusCode,
            'statusMessage': statusMessage,
          };
  }

  @override
  String toString() {
    return const JsonEncoder.withIndent('  ').convert(toJson());
  }
}

/// wrapper for request
class RequestWrapper<T> {
  /// response future
  final Future<ResponseWrapper<T>> resp;

  /// cancel token (internal)
  final CancelToken? _cancelToken;

  /// whether the request is cancelable
  bool get cancelable => _cancelToken != null;

  /// cancel the request (only if cancelable)
  void cancel() {
    _cancelToken?.cancel();
  }

  RequestWrapper({required this.resp, required CancelToken? cancelToken})
      : _cancelToken = cancelToken;
}

/// request impl
///
/// to config [baseUrl], use environment variable `request_base_url`
abstract class RequestImpl {
  static String baseUrl = const String.fromEnvironment('request_base_url');

  /// base request implementation, called internally
  ///
  /// [method] 'GET', 'POST', 'PUT', 'DELETE', etc.
  /// [path] request path, contact with [baseUrl] to form the full url
  /// [cancelable] whether the request is cancelable
  /// [queryParameters] query parameters
  /// [data] request data
  /// [passThrough] customized data that will be passed through
  /// [headerBuilder] header builder that will be used to build headers for request
  /// [dataBuilder] data builder that will be used to build data before request
  /// [dataParser] data parser that will be used to parse data from response
  static RequestWrapper<T> base<T>(
    String method,
    String path, {
    bool cancelable = false,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    dynamic passThrough,
    HeaderBuilder? headerBuilder,
    DataBuilder<T>? dataBuilder,
    DataParser<T>? dataParser,
  }) {
    BaseOptions options = BaseOptions(
      method: method,
      baseUrl: baseUrl,
      headers: headerBuilder?.call(passThrough),
    );
    final CancelToken? cancelToken = cancelable ? CancelToken() : null;
    final Dio instance = Dio(options);

    // apply 'dataBuilder' if exists
    if (dataBuilder != null) data = dataBuilder(data, passThrough);

    // wrap the request
    final Future<ResponseWrapper<T>> resp = Future(
      () async => ResponseWrapper.fromResponse<T>(
        await instance.request(
          path,
          queryParameters: queryParameters,
          data: data,
          cancelToken: cancelToken,
        ),
        dataParser,
        passThrough,
      ),
    );

    return RequestWrapper<T>(resp: resp, cancelToken: cancelToken);
  }

  /// GET implementation
  static RequestWrapper<T> get<T>(
    String path, {
    bool cancelable = false,
    Map<String, dynamic>? queryParameters,
    dynamic passThrough,
    HeaderBuilder? headerBuilder,
    DataParser<T>? dataParser,
  }) {
    return base(
      'GET',
      path,
      cancelable: cancelable,
      queryParameters: queryParameters,
      passThrough: passThrough,
      headerBuilder: headerBuilder,
      dataParser: dataParser,
    );
  }

  /// POST implementation
  static RequestWrapper<T> post<T>(
    String path, {
    bool cancelable = false,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    dynamic passThrough,
    HeaderBuilder? headerBuilder,
    DataBuilder<T>? dataBuilder,
    DataParser<T>? dataParser,
  }) {
    return base(
      'POST',
      path,
      cancelable: cancelable,
      queryParameters: queryParameters,
      data: data,
      passThrough: passThrough,
      headerBuilder: headerBuilder,
      dataBuilder: dataBuilder,
      dataParser: dataParser,
    );
  }

  /// PUT implementation
  static RequestWrapper<T> put<T>(
    String path, {
    bool cancelable = false,
    Map<String, dynamic>? queryParameters,
    dynamic passThrough,
    HeaderBuilder? headerBuilder,
    DataParser<T>? dataParser,
  }) {
    return base(
      'PUT',
      path,
      cancelable: cancelable,
      queryParameters: queryParameters,
      passThrough: passThrough,
      headerBuilder: headerBuilder,
      dataParser: dataParser,
    );
  }

  /// DELETE implementation
  static RequestWrapper<T> delete<T>(
    String path, {
    bool cancelable = false,
    Map<String, dynamic>? queryParameters,
    dynamic passThrough,
    HeaderBuilder? headerBuilder,
    DataParser<T>? dataParser,
  }) {
    return base(
      'DELETE',
      path,
      cancelable: cancelable,
      queryParameters: queryParameters,
      passThrough: passThrough,
      headerBuilder: headerBuilder,
      dataParser: dataParser,
    );
  }

  /// GET the document as-is
  static RequestWrapper<T> rawGet<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    DataParser<T>? dataParser,
    dynamic passThrough,
  }) {
    final Future<ResponseWrapper<T>> resp = Future(() async {
      BaseOptions options = BaseOptions();
      final Response<dynamic> resp = await Dio(options).get(
        path,
        queryParameters: queryParameters,
      );

      return ResponseWrapper.raw(resp, dataParser, passThrough);
    });

    return RequestWrapper<T>(resp: resp, cancelToken: null);
  }
}
