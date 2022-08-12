import 'package:flutter/material.dart';
import 'package:new_flutter_gauge/new_flutter_gauge.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gauge Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gauge Example'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        children: [
          const FlutterGauge(
            index: 50,
            hand: Hand.short,
            number: Number.endAndCenterAndStart,
            secondsMarker: SecondsMarker.secondsAndMinute,
            counterStyle: TextStyle(
              color: Colors.black,
              fontSize: 25,
            ),
          ),
          const FlutterGauge(
            secondsMarker: SecondsMarker.none,
            hand: Hand.short,
            number: Number.none,
            width: 200,
            index: 38.0,
            counterStyle: TextStyle(
              color: Colors.black,
              fontSize: 35,
            ),
            counterAlign: CounterAlign.center,
            isDecimal: false,
          ),
          const FlutterGauge(
            handSize: 30,
            width: 200,
            index: 50.0,
            end: 100,
            number: Number.endAndCenterAndStart,
            secondsMarker: SecondsMarker.secondsAndMinute,
            counterStyle: TextStyle(
              color: Colors.black,
              fontSize: 25,
            ),
          ),
          const FlutterGauge(
            handSize: 30,
            width: 200,
            index: 65.0,
            end: 500,
            number: Number.endAndStart,
            secondsMarker: SecondsMarker.minutes,
            isCircle: false,
            counterStyle: TextStyle(
              color: Colors.black,
              fontSize: 25,
            ),
          ),
          Container(
            color: Colors.black38,
            child: const FlutterGauge(
              inactiveColor: Colors.white38,
              activeColor: Colors.white,
              handSize: 30,
              width: 200,
              index: 65.0,
              end: 400,
              number: Number.none,
              secondsMarker: SecondsMarker.minutes,
              isCircle: false,
              hand: Hand.none,
              counterAlign: CounterAlign.center,
              counterStyle: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
              isDecimal: false,
            ),
          ),
          const FlutterGauge(
            index: 50.0,
            counterStyle: TextStyle(
              color: Colors.black,
              fontSize: 25,
            ),
            widthCircle: 10,
            secondsMarker: SecondsMarker.none,
            number: Number.all,
          ),
        ],
      ),
    );
  }
}
