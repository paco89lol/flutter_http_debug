import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../http_debug/data/http_record_entity.dart';
import '../../http_debug/http_debug.dart';


class DioInterceptor extends Interceptor {

  HttpsDebug httpsDebugController;

  DioInterceptor({
    required this.httpsDebugController,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // TODO: implement onRequest
    options.extra['request_created_at'] = DateTime.now().millisecondsSinceEpoch;
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // TODO: implement onError
    final httpRecord = toErrorHttpRecordEntity(dioException:err);
    httpsDebugController.addRecord(httpRecord: httpRecord);
    super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // TODO: implement onResponse

    final httpRecord = toHttpRecordEntity(response: response);
    httpsDebugController.addRecord(httpRecord: httpRecord);
    super.onResponse(response, handler);
  }

  static HttpRecordEntity toHttpRecordEntity({required Response<dynamic> response}) {

    // Get the Content-Type header
    final requestMimeType = response.requestOptions.contentType;

    // Get the Content-Type header
    final responseMimeType = response.headers.value('Content-Type');

    final isImageOrAudio = ((requestMimeType != null) && (requestMimeType.contains("image") || requestMimeType.contains("audio")))? true: false;

    final isJsonRequestBody = (requestMimeType != null && requestMimeType.toLowerCase().contains("json"));

    String? requestBody;

    if (isJsonRequestBody) {

      try {

        if (response.requestOptions.data is Map<String, dynamic>) {
          requestBody = JsonEncoder.withIndent('  ')
              .convert(response.requestOptions.data);
        } else {
          requestBody = JsonEncoder.withIndent('  ')
              .convert(jsonDecode(response.requestOptions.data));
        }
      } catch (e) {
        // Handle errors gracefully
      }

    } else {
      requestBody = response.requestOptions.data.toString();
    }

    if (requestBody == "null") {
      requestBody = null;
    }

    // Calculate the duration
    double? duration;

    int? requestCreatedAt = response.requestOptions.extra['request_created_at'];
    DateTime? datetime;

    if (requestCreatedAt != null) {
      datetime = DateTime.fromMillisecondsSinceEpoch(requestCreatedAt);
      final now = DateTime.now().millisecondsSinceEpoch;
      duration = (now - requestCreatedAt) / 1000.0;
    }

    final responseHeaders = response.headers.map.map((k,v) {
      String newValue = v.isNotEmpty ? v.join(', ') : '';
      return MapEntry(k,newValue);
    });

    String? responseBody;

    if (!isImageOrAudio) {

      final isJsonResponseBody = (responseMimeType != null && responseMimeType.toLowerCase().contains("json"));

      if (isJsonResponseBody) {

        try {
          if (response.data is Map<String, dynamic>) {
            responseBody = JsonEncoder.withIndent('  ')
                .convert(response.data);
          } else {
            responseBody = JsonEncoder.withIndent('  ')
                .convert(jsonDecode(response.data));
          }

        } catch (e) {
          // Handle errors gracefully
        }

      } else {
        responseBody = response.data.toString();
      }

      if (responseBody == "null") {
        responseBody = null;
      }
    }

    int responseSize = ByteUtil.stringToBytes(response.data.toString());
    final responseFormattedSize = ByteUtil.formattedSize(responseSize);

    return HttpRecordEntity(
      method: response.requestOptions.method,
      url: response.requestOptions.uri.toString(),
      requestHeaders: response.requestOptions.headers,
      requestBody: requestBody,
      responseHeaders: responseHeaders,
      responseMimeType: responseMimeType,
      responseBody: responseBody,
      responseCode: response.statusCode,
      size: responseFormattedSize,
      duration: duration,
      requestCreatedAt: datetime,
    );

  }

  static HttpRecordEntity toErrorHttpRecordEntity({required DioException dioException}) {

    // Get the Content-Type header
    final requestMimeType = dioException.requestOptions.contentType;

    // Get the Content-Type header
    final responseMimeType = dioException.response?.headers.value('Content-Type');

    final isImageOrAudio = ((responseMimeType != null) && (responseMimeType.contains("image") || responseMimeType.contains("audio")))? true: false;

    final isJsonRequestBody = (requestMimeType != null && requestMimeType.toLowerCase().contains("json"));

    String? requestBody;

    if (isJsonRequestBody) {

      try {

        if (dioException.requestOptions.data is Map<String, dynamic>) {
          requestBody = JsonEncoder.withIndent('  ')
              .convert(dioException.requestOptions.data);
        } else {
          requestBody = JsonEncoder.withIndent('  ')
              .convert(jsonDecode(dioException.requestOptions.data));
        }

      } catch (e) {
        // Handle errors gracefully
      }

    } else {
      requestBody = dioException.requestOptions.data.toString();
    }

    if (requestBody == "null") {
      requestBody = null;
    }


    // Calculate the duration
    double? duration;

    int? requestCreatedAt = dioException.requestOptions.extra['request_created_at'];
    DateTime? datetime;

    if (requestCreatedAt != null) {
      datetime = DateTime.fromMillisecondsSinceEpoch(requestCreatedAt);
      final now = DateTime.now().millisecondsSinceEpoch;
      duration = (now - requestCreatedAt) / 1000.0;
    }

    final responseHeaders = dioException.response?.headers.map.map((k,v) {
      String newValue = v.isNotEmpty ? v.join(', ') : '';
      return MapEntry(k,newValue);
    });

    String? responseBody;

    if (!isImageOrAudio) {

      final isJsonResponseBody = (responseMimeType != null && responseMimeType.toLowerCase().contains("json"));

      if (isJsonResponseBody) {

        try {

          if (dioException.response?.data is Map<String, dynamic>) {
            responseBody = JsonEncoder.withIndent('  ')
                .convert(dioException.response?.data);
          } else {
            responseBody = JsonEncoder.withIndent('  ')
                .convert(jsonDecode(dioException.response?.data));
          }

        } catch (e) {
          // Handle errors gracefully
        }

      } else {
        responseBody = dioException.response?.data.toString();
      }

      if (responseBody == "null") {
        responseBody = null;
      }
    }

    String? responseFormattedSize;
    final response = dioException.response;

    if (response != null) {
      int responseSize = ByteUtil.stringToBytes(response.data.toString());
      responseFormattedSize = ByteUtil.formattedSize(responseSize);
    }

    String? errorDescription;
    if (dioException.error is DioException) {
      final exc = dioException.error as DioException;
      errorDescription = exc.message;
    }

    return HttpRecordEntity(
      method: dioException.requestOptions.method,
      url: dioException.requestOptions.uri.toString(),
      requestHeaders: dioException.requestOptions.headers,
      requestBody: requestBody,
      responseMimeType: responseMimeType,
      responseBody: responseBody,
      responseHeaders: responseHeaders,
      responseCode: dioException.response?.statusCode,
      size: responseFormattedSize,
      duration: duration,
      requestCreatedAt: datetime,
      error: dioException.response?.statusMessage,
      errorDescription: errorDescription,
    );

  }

  
}


class ByteUtil {

  static int stringToBytes(String data) {
    final bytes = utf8.encode(data);
    final size = Uint8List.fromList(bytes);
    return size.lengthInBytes;
  }

  static String formattedSize(int bytes) {

    if (bytes < 1024.0) {
      return "$bytes bytes";
    } else {
      final val = (bytes / 1024.0).toStringAsFixed(1);
      return "$val kb";
    }

  }
}