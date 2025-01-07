import 'package:flutter/material.dart';
import 'package:everlink_sdk/everlink_sdk.dart';
import 'package:everlink_sdk/everlink_error.dart';
import 'dart:async';
import 'dart:developer';

class EmitterScreen extends StatefulWidget {
  const EmitterScreen({super.key});

  @override
  State<EmitterScreen> createState() => _MyAppState();
}

class _MyAppState extends State<EmitterScreen> {
  final _everlinkSdk = EverlinkSdk("FlutterTestKey12345");
  bool isEmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _everlinkPlayVolume(0.8, true);
      const tokensList = [
        //token valid until 07/02/2025
        'evpan99eede86a8d9eae8ecc174511ee93a2d',
        'evpanffc8003b43ca9e0ba76eb8087f8c3095',
        'evpan97b79f15a26326301cafc41b4b0e8696'
      ];
      await _everlinkSaveTokens(tokensList);
    });
  }

  Future<void> _everlinkPlayVolume(double volume, bool loudSpeaker) async {
    try {
      await _everlinkSdk.playVolume(volume, loudSpeaker);
      print('Volume changed successfully.');
    } on EverlinkError catch (e) {
      print('Error occurred: ${e.toString()}');
    } catch (e) {
      print('Unexpected error: $e');
    }
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

  Future<void> _everlinkStartEmittingToken(String token) async {
    if (isEmitting) {
      _everlinkStopEmitting();
      //can only emit 1 token at a time, so stop any token currently emitting
      Future.delayed(const Duration(milliseconds: 500), () async {
        await _emitToken(token);
        //Everlink stops detecting after returning a token.
        //You will need to call startDetecting() again to detect another audiocode.
      });
    } else {
      await _emitToken(token);
    }
  }

  Future<void> _emitToken(String token) async {
    try {
      if (isEmitting) {
        _everlinkStopEmitting();
        //can only emit 1 token at a time, so stop any token currently emitting
      }
      isEmitting = true;
      await _everlinkSdk.startEmittingToken(token);
      log('Started emitting token successfully.');
    } on EverlinkError catch (e) {
      log('Error occurred: ${e.toString()}');
    } catch (e) {
      log('Unexpected error: $e');
    }
  }

  Future<void> _everlinkStopEmitting() async {
    try {
      isEmitting = false;
      await _everlinkSdk.stopEmitting();
      log('Stopped emitting successfully.');
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
        title: const Text('Emitter Screen'),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
            child: const Text('Start play token 1'),
            onPressed: () async {
              await _everlinkStartEmittingToken(
                  'evpan99eede86a8d9eae8ecc174511ee93a2d');
            },
          ),
          ElevatedButton(
            child: const Text('Start play token 2'),
            onPressed: () async {
              await _everlinkStartEmittingToken(
                  'evpanffc8003b43ca9e0ba76eb8087f8c3095');
            },
          ),
          ElevatedButton(
            child: const Text('Start play token 3'),
            onPressed: () async {
              await _everlinkStartEmittingToken(
                  'evpan97b79f15a26326301cafc41b4b0e8696');
            },
          ),
          ElevatedButton(
            child: const Text('Stop play'),
            onPressed: () async {
              await _everlinkStopEmitting();
            },
          ),
        ]),
      ),
    );
  }
}
