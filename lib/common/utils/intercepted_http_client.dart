

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../http_debug/data/http_record_entity.dart';
import '../../http_debug/http_debug.dart';
import 'dio_interceptor.dart';

class InterceptedHttpClient extends http.BaseClient {

  HttpsDebug httpsDebugController;

  final http.Client httpClient;

  InterceptedHttpClient({
    required this.httpsDebugController,
    required this.httpClient,
  });

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final requestCreatedAt = DateTime.now().millisecondsSinceEpoch;
    final requestDateTime = DateTime.now();

    // Intercept and modify the request
    _onRequest(request);

    try {
      // Send the request
      final response = await httpClient.send(request);

      // Calculate request duration
      final now = DateTime.now().millisecondsSinceEpoch;
      final duration = (now - requestCreatedAt) / 1000.0;

      // Intercept and process the response
      _onResponse(request, response, requestDateTime, duration);

      return response;
    } catch (error, stackTrace) {
      // Calculate request duration
      final now = DateTime.now().millisecondsSinceEpoch;
      final duration = (now - requestCreatedAt) / 1000.0;

      // Intercept and handle errors
      _onError(request, error, stackTrace, requestDateTime, duration);
      rethrow; // Re-throw the error after handling it
    }
  }

  void _onRequest(http.BaseRequest request) {}

  Future<void> _onResponse(
      http.BaseRequest request,
      http.StreamedResponse response,
      DateTime requestCreatedAt,
      double duration,
      ) async {

    // Get the Content-Type header
    final requestMimeType = request.headers.map((k,v) {
      return MapEntry(k.toLowerCase(),v);
    })['content-type'];

    final isJsonRequestBody = (requestMimeType != null && requestMimeType!.toLowerCase().contains("json"));

    String? requestBody;

    if (isJsonRequestBody) {

      try {

        if (request is http.Request) {
          Map<String, dynamic> jsonMap = json.decode(request.body);
          requestBody = JsonEncoder.withIndent('  ')
              .convert(jsonMap);
        }

      } catch (e) {
        // Handle errors gracefully
      }

    } else {

      if (request is http.Request) {
        requestBody = request.body;
      }

    }

    if (requestBody == "null") {
      requestBody = null;
    }

    // Determine response MIME type
    final responseMimeType = response.headers['content-type'];
    final isImageOrAudio = ((responseMimeType != null) && (responseMimeType.contains("image") || responseMimeType.contains("audio")))? true: false;

    // Read and parse the response body
    final responseBodyString = await response.stream.bytesToString();

    String? responseBody;

    if (!isImageOrAudio) {

      final isJsonResponseBody = (responseMimeType != null && responseMimeType!.toLowerCase().contains("json"));

      if (isJsonResponseBody) {

        try {

          Map<String, dynamic> jsonMap = json.decode(responseBodyString);
          responseBody = JsonEncoder.withIndent('  ')
              .convert(jsonMap);

        } catch (e) {
          // Handle errors gracefully
        }

      } else {
        responseBody = responseBodyString;
      }

      if (responseBody == "null") {
        responseBody = null;
      }
    }

    // Calculate size of response body
    int responseSize = ByteUtil.stringToBytes(responseBodyString);
    final responseFormattedSize = ByteUtil.formattedSize(responseSize);


    // Create an HttpRecordEntity instance
    final httpRecord = HttpRecordEntity(
      method: request.method,
      url: request.url.toString(),
      requestHeaders: request.headers,
      requestBody: requestBody,
      responseHeaders: response.headers,
      responseMimeType: responseMimeType,
      responseBody: responseBody,
      responseCode: response.statusCode,
      size: responseFormattedSize,
      duration: duration,
      requestCreatedAt: DateTime.now(),
    );

    httpsDebugController.addRecord(httpRecord: httpRecord);
  }

  void _onError(
      http.BaseRequest request,
      Object error,
      StackTrace stackTrace,
      DateTime requestCreatedAt,
      double duration,
      ) {
    // Get the Content-Type header for the request
    final requestMimeType = request.headers.map((k, v) {
      return MapEntry(k.toLowerCase(), v);
    })['content-type'];

    final isJsonRequestBody =
    (requestMimeType != null && requestMimeType.toLowerCase().contains("json"));

    String? requestBody;

    if (isJsonRequestBody) {
      try {
        if (request is http.Request) {
          Map<String, dynamic> jsonMap = json.decode(request.body);
          requestBody = JsonEncoder.withIndent('  ').convert(jsonMap);
        }
      } catch (e) {
        // Handle errors gracefully
      }
    } else {
      if (request is http.Request) {
        requestBody = request.body;
      }
    }

    if (requestBody == "null") {
      requestBody = null;
    }

    // Extract general error information
    final errorDescription = error.toString();
    final errorLog = stackTrace.toString();

    // Create an HttpRecordEntity instance for the error
    final httpRecord = HttpRecordEntity(
      method: request.method,
      url: request.url.toString(),
      requestHeaders: request.headers,
      requestBody: requestBody,
      responseHeaders: null, // No response headers for errors
      responseMimeType: null, // No response MIME type for errors
      responseBody: null, // No response body for errors
      errorLog: errorLog,
      responseCode: null, // No response code for errors
      size: null, // No size for errors
      duration: duration,
      requestCreatedAt: requestCreatedAt,
      error: error.runtimeType.toString(),
      errorDescription: errorDescription,
    );

    httpsDebugController.addRecord(httpRecord: httpRecord);
  }
}
