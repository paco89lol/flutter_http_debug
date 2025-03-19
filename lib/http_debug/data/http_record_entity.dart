

class HttpRecordEntity {



  final String method;
  final String url;
  final Map<String, dynamic>? requestHeaders;
  final String? requestBody;
  final Map<String, dynamic>? responseHeaders;
  final String? responseMimeType;
  final String? responseBody;
  final String? errorLog;
  final int? responseCode;
  final String? size;
  final double? duration;
  final DateTime? requestCreatedAt;
  final String? error;
  final String? errorDescription;

  HttpRecordEntity({
    required this.method,
    required this.url,
    this.requestHeaders,
    this.requestBody,
    this.responseHeaders,
    this.responseMimeType,
    this.responseBody,
    this.errorLog,
    this.responseCode,
    this.size,
    required this.duration,
    required this.requestCreatedAt,
    this.error,
    this.errorDescription,
  });

  String toClipboardString() {
    final buffer = StringBuffer();

    // Format the HTTP method, timestamp, and response code
    buffer.writeln("[$method] ${requestCreatedAt?.toIso8601String()} (${responseCode ?? 'N/A'})");

    // URL
    buffer.writeln("\n------- URL -------");
    buffer.writeln(url);

    // Request Headers
    if (requestHeaders != null && requestHeaders!.isNotEmpty) {
      buffer.writeln("\n------- REQUEST HEADER -------");
      requestHeaders!.forEach((key, value) {
        buffer.writeln('"$key" : "$value",');
      });
    }

    // Request Body
    if (requestBody != null && requestBody!.isNotEmpty) {
      buffer.writeln("\n------- REQUEST BODY -------");
      buffer.writeln(requestBody);
    }

    // Response Headers
    if (responseHeaders != null && responseHeaders!.isNotEmpty) {
      buffer.writeln("\n------- RESPONSE HEADER -------");
      responseHeaders!.forEach((key, value) {
        buffer.writeln('"$key" : "$value",');
      });
    }

    // Response Body
    if (responseBody != null && responseBody!.isNotEmpty) {
      buffer.writeln("\n------- RESPONSE -------");
      buffer.writeln(responseBody);
    }

    // Response size
    if (size != null) {
      buffer.writeln("\n------- RESPONSE SIZE -------");
      buffer.writeln(size);
    }

    // Total time
    if (duration != null) {
      buffer.writeln("\n------- TOTAL TIME -------");
      buffer.writeln("${duration?.toStringAsFixed(6)} (s)");
    }


    // MIME Type
    if (responseMimeType != null && responseMimeType!.isNotEmpty) {
      buffer.writeln("\n------- MIME TYPE -------");
      buffer.writeln(responseMimeType);
    }

    // Error (if any)
    if (error != null && error!.isNotEmpty) {
      buffer.writeln("\n------- ERROR -------");
      buffer.writeln(error);
    }

    if (errorDescription != null && errorDescription!.isNotEmpty) {
      buffer.writeln("\n------- ERROR DESCRIPTION -------");
      buffer.writeln(errorDescription);
    }

    return buffer.toString();
  }

}