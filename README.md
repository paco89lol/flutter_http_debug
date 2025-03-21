The http_debug library simplifies debugging HTTP requests and responses in Flutter applications. It provides a floating debug button `HttpDebugFloatingButton` that overlays your app's UI, offering real-time access to HTTP traffic. With this tool, you can inspect and analyze requests, headers, payloads, and responses directly within your app, without relying on external tools like Postman or browser developer tools.

<table>
  <tr>
    <td>
        <img src="https://github.com/user-attachments/assets/da7eec6f-e5d0-4259-8a1a-b42acc99fbba" width="250px">
    </td>
    <td>
        <img src="https://github.com/user-attachments/assets/42dd368d-549f-49e6-9a91-f1633a83eb59" width="250px">
    </td>
    <td>
        <img src="https://github.com/user-attachments/assets/9f411f38-9d2b-480d-83b1-ce693087ab60" width="250px">
    </td>
    <td>
        <img src="https://github.com/user-attachments/assets/07b494b9-2c99-4548-970e-e4c40adb0e42" width="250px">
    </td>
  </tr>
</table>

<table>
  <tr>
    <td>
        <img src="https://github.com/user-attachments/assets/a7642bbe-2a91-4798-8a04-88c4ed4778dc" width="250px">
    </td>
    <td>
        <img src="https://github.com/user-attachments/assets/5b3ea3f5-3c75-4418-8bb5-75b2c437b85c" width="250px">
    </td>
    <td>
        <div width="250px">
    </td>
    <td>
        <div width="250px">
    </td>
  </tr>
</table>

https://github.com/user-attachments/assets/64818d4f-31c6-4b19-902e-7c95dce4127c




# Get Started
add dependency
```yaml
dependencies:
  http_debug: ^1.0.2
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

