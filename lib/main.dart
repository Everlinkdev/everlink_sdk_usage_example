import 'package:flutter/material.dart';
import 'package:everlink_example_flutter/emitter_screen.dart';
import 'package:everlink_example_flutter/detector_screen.dart';
import 'package:everlink_sdk/everlink_sdk.dart';
import 'package:everlink_sdk/everlink_sdk_event.dart';
import 'package:everlink_sdk/everlink_error.dart';
import 'dart:async';
import 'dart:developer';

void main() {
  runApp(const MaterialApp(
    title: 'Everlink Example',
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _everlinkSdk = EverlinkSdk("FlutterTestKey12345");

  @override
  void initState() {
    super.initState();
    _listenToSdkEvents();
  }

  void _listenToSdkEvents() {
    _everlinkSdk.onEvent.listen((event) {
      if (event is GeneratedTokenEvent) {
        log('Generated token: Old - ${event.oldToken}, New - ${event.newToken}');
        saveTokenToYourDatabase(event.newToken);
      }
    }, onError: (error) {
      log('Error receiving SDK event: $error');
    });
  }

  @override
  void dispose() {
    // Dispose the EverlinkSdk instance to release resources
    _everlinkSdk.dispose();
    super.dispose();
  }

  void saveTokenToYourDatabase(String token) {
    // A new token generated. This token should be associated with a user in your database.
  }

  Future<void> _everlinkNewToken() async {
    try {
      const date = ""; //empty string for token to become valid today
      await _everlinkSdk.newToken(date);
    } on EverlinkError catch (e) {
      log('Error occurred: ${e.toString()}');
    } catch (e) {
      log('Unexpected error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Everlink Example'),
        ),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              child: const Text('Generate new token'),
              onPressed: () async {
                await _everlinkNewToken();
              },
            ),
            ElevatedButton(
              child: const Text('Go to Emitter screen'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EmitterScreen()),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Go to Detector screen'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DetectorScreen()),
                );
              },
            ),
          ]),
        ));
  }
}
