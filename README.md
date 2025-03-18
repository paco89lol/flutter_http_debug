

# Get Started
add dependency
```yaml
dependencies:
  http_debug: ^0.0.1
```

# Initialize
In the `MaterialApp` widget, use the `builder` parameter to wrap your app's widget tree with the `HttpDebugFloatingButton`, ensuring it is accessible globally throughout your app.

```dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        routes: {
          '/': (context) => HomePage(), // Default route
          '/sendRequest': (context) => SendRequestDetailPage(),
        },
        initialRoute: '/', // Set the initial route
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return Stack(
            children: [
              child!,
              HttpDebugFloatingButton(),
            ],
          );
        }
    );
  }
}
```


# Dio Users
1. Add interceptor class `DioInterceptor` for dio client.
```dart

Dio get dioClient{
  final client = Dio()..interceptors.add(
    DioInterceptor(),
  );
  return client;
}

/// Use dio regularly
dio.get(
  'https://api.ipify.og?format=json',
  options: Options(headers: {"abc": "abc"}),
);

```

# Http Users
1. Initialize `Client` to client class, then use `httpClient` on the `InterceptedHttpClient` constructor
```dart
HttpInterceptor get httpClient {
  InterceptedHttpClient(
    httpsDebugController: HttpsDebug.instance,
    httpClient: http.Client(),
  );
}

/// Use http client regularly
await client.get(
  Uri.parse('https://api.ipify.org?format=json'),
  headers: {"abc": "abc"},
);
```

# Acessing the UI

