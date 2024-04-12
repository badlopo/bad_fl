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

/// 响应包装器
class ResponseWrapper<T> {
  final int? statusCode;
  final String? statusMessage;

  final String? globalId;
  final int? code;
  final String? msg;
  final int? pageNo;
  final int? pageSize;
  final int? pageTotal;

  /// 详细的响应数据
  /// - 解密前为 String
  /// - 解密后为 String 或 Map 等类型
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

    // 响应值非 Map, 则直接返回 (文件上传时, 响应值为 String)
    if (response.data is! Map) {
      return ResponseWrapper<T>._(
        // 标识为成功
        code: 200,
        data: response.data,
      );
    }

    Map<String, dynamic> data = response.data;
    // 请求发生错误
    if (data['code'] != 200) {
      return ResponseWrapper<T>._(
        globalId: data['globalId'],
        code: data['code'],
        msg: data['msg'],
      );
    }

    // 原始值
    final raw = data['data'];
    // 空值处理
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

    // 返回包装器
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

/// 请求包装器
class RequestWrapper<T> {
  /// 响应
  final Future<ResponseWrapper<T>> resp;

  /// 取消令牌, 内部维护
  final CancelToken? _cancelToken;

  /// 是否可取消
  bool get cancelable => _cancelToken != null;

  /// 取消请求, 仅当 [cancelable] 为 true 时有效, 否则忽略
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
  static const String baseUrl = String.fromEnvironment('request_base_url');

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
    String method,
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
    String method,
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
    String method,
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
}
