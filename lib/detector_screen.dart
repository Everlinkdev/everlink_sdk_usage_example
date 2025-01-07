import 'package:flutter/material.dart';
import 'package:everlink_sdk/everlink_sdk.dart';
import 'package:everlink_sdk/everlink_sdk_event.dart';
import 'package:everlink_sdk/everlink_error.dart';
import 'dart:async';
import 'dart:developer';

class DetectorScreen extends StatefulWidget {
  const DetectorScreen({super.key});

  @override
  State<DetectorScreen> createState() => _MyAppState();
}

class _MyAppState extends State<DetectorScreen> {
  final _everlinkSdk = EverlinkSdk("FlutterTestKey12345");

  @override
  void initState() {
    super.initState();
    _listenToSdkEvents();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      const tokensList = [
        //token valid until 07/02/2025
        'evpan99eede86a8d9eae8ecc174511ee93a2d',
        'evpanffc8003b43ca9e0ba76eb8087f8c3095',
        'evpan97b79f15a26326301cafc41b4b0e8696'
      ];
      await _everlinkSaveTokens(tokensList);
    });
  }

  void _listenToSdkEvents() {
    _everlinkSdk.onEvent.listen((event) {
      if (event is DetectionEvent) {
        doSomethingWithDetectedToken(event.detectedToken);
      }
    }, onError: (error) {
      log('Error receiving SDK event: $error');
    });
  }

  Future<void> _everlinkSaveTokens(List<String> tokens) async {
    try {
      await _everlinkSdk.saveTokens(tokens);
      log('Tokens saved successfully.');
    } on EverlinkError catch (e) {
      log('Error occurred: ${e.toString()}');
    } catch (e) {
      log('Unexpected error: $e');
    }
  }

  @override
  void dispose() {
    // Dispose the EverlinkSdk instance to release resources
    _everlinkSdk.dispose();
    super.dispose();
  }

  void doSomethingWithDetectedToken(String token) {
    //Here you can use the returned token to verify this user
    showDialog(
      context: context,
      // Mark is as no-dismissible to make it dismiss based on time
      barrierDismissible: false,
      builder: (context) {
        // This method will invoke after a second and will dismiss the alert dialog box
        // Adjust the seconds from here
        Future.delayed(const Duration(milliseconds: 500)).whenComplete(
          () => Navigator.pop(context),
        );

        return AlertDialog(
          backgroundColor: const Color.fromRGBO(7, 250, 52, 1.0),
          title: const Text(
            'User Detected!',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          content: Text(
            token,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
            ),
          ),
        );
      },
    );

    Future.delayed(const Duration(milliseconds: 1000), () async {
      await _everlinkStartDetecting();
      //Everlink stops detecting after returning a token.
      //You will need to call startDetecting() again to detect another audiocode.
    });
  }

  Future<void> _everlinkStartDetecting() async {
    try {
      await _everlinkSdk.startDetecting();
      log('Detection started successfully.');
    } on EverlinkError catch (e) {
      log('Error occurred: ${e.toString()}');
    } catch (e) {
      log('Unexpected error: $e');
    }
  }

  Future<void> _everlinkStopDetecting() async {
    try {
      await _everlinkSdk.stopDetecting();
      log('Detection stopped successfully.');
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
        title: const Text('Detector Screen'),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
            child: const Text('Start detecting'),
            onPressed: () async {
              await _everlinkStartDetecting();
            },
          ),
          ElevatedButton(
            child: const Text('Stop detecting'),
            onPressed: () async {
              await _everlinkStopDetecting();
            },
          ),
        ]),
      ),
    );
  }
}
