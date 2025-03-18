import 'dart:math';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http_debug/common/utils/dio_interceptor.dart';
import 'package:http_debug/common/utils/intercepted_http_client.dart';
import 'package:http_debug/http_debug/http_debug.dart';

final dio = createDio();

Dio createDio() {
  final dio = Dio();
  dio.interceptors.add(
    DioInterceptor(httpsDebugController: HttpsDebug.instance),
  );
  return dio;
}

void sendDioHttpRequest() {
  int num = Random().nextInt(100);

  try {
    if (num % 6 == 0) {
      final xmlBody = '''
  <?xml version="1.0" encoding="utf-8"?>
<Request>
    <Login>login</Login>
    <Password>password</Password>
</Request>
  ''';

      dio.post(
        'https://reqbin.com/echo/post/xml', // Replace with your URL
        data: xmlBody, // XML body
        options: Options(
          headers: {
            'Content-Type': 'application/xml', // Set the content type to XML
            'Accept': 'application/xml', // Optional: for XML responses
          },
        ),
      );
    } else if (num % 6 == 1) {
      final jsonBody = '''
{
  "Id": 78912,
  "Customer": "Jason Sweet",
  "Quantity": 1,
  "Price": 18.00
}
    ''';

      dio.post(
        'https://reqbin.com/echo/post/json',
        data: jsonBody,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
    } else if (num % 6 == 2) {
      final jsonBody1 = '''
    ''';

      dio.get(
        'https://reqbin.com/echo/get/json/page/2',
        data: jsonBody1,
        options: Options(headers: {'Accept': 'application/json'}),
      );
    } else if (num % 6 == 3) {
      dio.get('https://httpstat.us/304');
    } else if (num % 6 == 4) {
      dio.get('https://httpstat.us/401');
    } else {
      dio.get('https://httpstat.us/404');
    }
    // Make a request

    dio.get(
      'https://api.ipify.og?format=json&request=1',
      options: Options(headers: {"abc": "abc"}),
    );

    // final requestHeaders = {"_abc": "_abc"};
    // dio.get('https://api.dicebear.com/9.x/adventurer/svg?seed=Aiden', options: Options(headers: {"abc": requestHeaders}));
  } catch (e) {
    print('Error: $e');
  }
}

void sendHttpRequest() async {
  // Create an instance of the InterceptedHttpClient
  final client = InterceptedHttpClient(
    httpsDebugController: HttpsDebug.instance,
    httpClient: http.Client(),
  );

  int num = Random().nextInt(100);

  try {
    // Handle different request types based on `num % 6`
    if (num % 6 == 0) {
      // XML Body Request
      final xmlBody = '''
<?xml version="1.0" encoding="utf-8"?>
<Request>
    <Login>login</Login>
    <Password>password</Password>
</Request>
''';

      final response = await client.post(
        Uri.parse('https://reqbin.com/echo/post/xml'), // Replace with your URL
        headers: {
          'Content-Type': 'application/xml', // Set the content type to XML
          'Accept': 'application/xml', // Optional: for XML responses
        },
        body: xmlBody,
      );

      print('Response (${response.statusCode}): ${response.body}');
    } else if (num % 6 == 1) {
      // JSON Body Request
      final jsonBody = '''
{
  "Id": 78912,
  "Customer": "Jason Sweet",
  "Quantity": 1,
  "Price": 18.00
}
''';

      final response = await client.post(
        Uri.parse('https://reqbin.com/echo/post/json'),
        headers: {'Content-Type': 'application/json'},
        body: jsonBody,
      );

      print('Response (${response.statusCode}): ${response.body}');
    } else if (num % 6 == 2) {
      // GET Request with JSON Accept Header
      final response = await client.get(
        Uri.parse('https://reqbin.com/echo/get/json/page/2'),
        headers: {'Accept': 'application/json'},
      );

      print('Response (${response.statusCode}): ${response.body}');
    } else if (num % 6 == 3) {
      // GET Request with 304 Response
      final response = await client.get(Uri.parse('https://httpstat.us/304'));

      print('Response (${response.statusCode}): ${response.body}');
    } else if (num % 6 == 4) {
      // GET Request with 401 Response
      final response = await client.get(Uri.parse('https://httpstat.us/401'));

      print('Response (${response.statusCode}): ${response.body}');
    } else {
      // GET Request with 404 Response
      final response = await client.get(Uri.parse('https://httpstat.us/404'));

      print('Response (${response.statusCode}): ${response.body}');
    }

    // Additional GET Request
    final response = await client.get(
      Uri.parse('https://api.ipify.org?format=json'),
      headers: {"abc": "abc"},
    );

    print('Response (${response.statusCode}): ${response.body}');
  } catch (e) {
    print('Error: $e');
  } finally {
    client.close(); // Always close the client
  }
}
