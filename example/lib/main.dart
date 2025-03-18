import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http_debug/http_debug/http_debug.dart';
import 'package:http_debug/http_debug/http_debug_floating_button.dart';

import 'demo_dio_code.dart';

void main() {
  HttpsDebug.instance.maxLength = 1000;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    ValueNotifier<bool> showFloatingButton = ValueNotifier(true);

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
              ValueListenableBuilder<bool>(
                valueListenable: showFloatingButton,
                builder: (context, value, child) {

                  if (!value && kReleaseMode) {
                    return const SizedBox.shrink();
                  }
                  // Add the global floating button
                  return HttpDebugFloatingButtonStyleTwo();
                },
              ),
            ],
          );
        }
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the SecondPage
            Navigator.pushNamed(context, '/sendRequest');
          },
          child: Text('Go to next page to send http request'),
        ),
      ),
    );
  }
}

class SendRequestDetailPage extends StatelessWidget {
  const SendRequestDetailPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Send Http Request Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // TODO - Send a simple http request
            sendHttpRequest();
          },
          child: Text('Send a http request'),
        ),
      ),
    );
  }
}