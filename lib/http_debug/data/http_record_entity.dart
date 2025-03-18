

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

}