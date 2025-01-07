import 'package:flutter/material.dart';
import 'package:everlink_example_flutter/emitter_screen.dart';
import 'package:everlink_example_flutter/detector_screen.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Everlink Example',
    home: FirstRoute(),
  ));
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Everlink Example'),
        ),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              child: const Text('Emitter'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EmitterScreen()),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Detector'),
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
