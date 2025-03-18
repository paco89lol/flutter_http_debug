import 'package:flutter/material.dart';
import 'package:http_debug/http_debug/http_debug_floating_button.dart';

import 'demo_dio_code.dart';

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