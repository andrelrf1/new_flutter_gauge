import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:new_flutter_gauge/widgets/gauge_widget.dart';

enum SecondsMarker { minutes, secondsAndMinute, all, none, seconds }

enum Number { all, endAndStart, endAndCenterAndStart, none }

enum NumberInAndOut { inside, outside }

enum CounterAlign { none, center, top, bottom }

enum Hand { none, long, short }

enum Animate { none, knock, forget }

class FlutterGauge extends StatefulWidget {
  final int start;
  final int end;
  final double widthCircle;
  final double index;
  final double? width;
  final Number number;
  final NumberInAndOut numberInAndOut;
  final CounterAlign counterAlign;
  final Hand hand;
  final bool isCircle;
  final double handSize;
  final bool isDecimal;
  final SecondsMarker secondsMarker;
  final double shadowHand;
  final Color circleColor;
  final Color handColor;
  final Color backgroundColor;
  final Color indicatorColor;
  final Color inactiveColor;
  final Color activeColor;
  final double paddingHand;
  final TextStyle? counterStyle;
  final TextStyle? textStyle;

  const FlutterGauge({
    this.isDecimal = true,
    this.inactiveColor = Colors.black,
    this.activeColor = Colors.red,
    this.textStyle,
    this.counterStyle,
    this.numberInAndOut = NumberInAndOut.inside,
    this.width,
    this.paddingHand = 30.0,
    this.circleColor = Colors.cyan,
    this.handColor = Colors.black,
    this.backgroundColor = Colors.cyan,
    this.indicatorColor = Colors.black,
    this.shadowHand = 4.0,
    this.counterAlign = CounterAlign.bottom,
    this.number = Number.all,
    this.isCircle = true,
    this.hand = Hand.long,
    this.secondsMarker = SecondsMarker.all,
    this.handSize = 30,
    this.start = 0,
    this.end = 100,
    required this.index,
    this.widthCircle = 20,
    Key? key,
  }) : super(key: key);

  @override
  _FlutterGaugeState createState() => _FlutterGaugeState();
}

class _FlutterGaugeState extends State<FlutterGauge> {
  PublishSubject<double> eventObservable = PublishSubject();

  @override
  void initState() {
    Timer(const Duration(milliseconds: 400), () {
      eventObservable.add(widget.index);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GaugeWidget(
      isDecimal: widget.isDecimal,
      counterStyle: widget.counterStyle,
      textStyle: widget.textStyle,
      numberInAndOut: widget.numberInAndOut,
      paddingHand: widget.paddingHand,
      circleColor: widget.circleColor,
      handColor: widget.handColor,
      backgroundColor: widget.backgroundColor,
      indicatorColor: widget.indicatorColor,
      shadowHand: widget.shadowHand,
      counterAlign: widget.counterAlign,
      number: widget.number,
      isCircle: widget.isCircle,
      hand: widget.hand,
      secondsMarker: widget.secondsMarker,
      handSize: widget.handSize,
      start: widget.start,
      end: widget.end,
      highlightStart: widget.end / widget.end.toInt(),
      highlightEnd: 0 / widget.end.toInt(),
      eventObservable: eventObservable,
      widthCircle: widget.widthCircle > 30 ? 30 : widget.widthCircle,
      inactiveColor: widget.inactiveColor,
      activeColor: widget.activeColor,
      width: widget.width == null
          ? MediaQuery.of(context).size.width / 2
          : widget.width! < (MediaQuery.of(context).size.width / 2)
              ? (MediaQuery.of(context).size.width / 2)
              : (widget.width! > (MediaQuery.of(context).size.width)
                  ? MediaQuery.of(context).size.width
                  : widget.width!),
    );
  }
}
