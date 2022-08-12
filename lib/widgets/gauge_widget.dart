import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:new_flutter_gauge/widgets/flutter_gauge_widget.dart';
import 'package:new_flutter_gauge/widgets/gauge_text_painter.dart';
import 'package:new_flutter_gauge/widgets/hand_painter.dart';
import 'package:new_flutter_gauge/widgets/line_painter.dart';

class GaugeWidget extends StatefulWidget {
  final int start;
  final int end;
  final double highlightStart;
  final double highlightEnd;
  final double widthCircle;
  final PublishSubject<double> eventObservable;
  final Number number;
  final CounterAlign counterAlign;
  final Hand hand;
  final bool isCircle;
  final double handSize;
  final SecondsMarker secondsMarker;
  final double shadowHand;
  final Color circleColor;
  final Color handColor;
  final Color backgroundColor;
  final Color indicatorColor;
  final double paddingHand;
  final double? width;
  final NumberInAndOut numberInAndOut;
  final TextStyle? counterStyle;
  final TextStyle? textStyle;
  final Color inactiveColor;
  final Color activeColor;
  final bool isDecimal;

  const GaugeWidget({
    required this.isDecimal,
    required this.inactiveColor,
    required this.activeColor,
    required this.textStyle,
    required this.counterStyle,
    required this.numberInAndOut,
    required this.width,
    required this.paddingHand,
    required this.circleColor,
    required this.handColor,
    required this.backgroundColor,
    required this.indicatorColor,
    required this.shadowHand,
    required this.counterAlign,
    required this.number,
    required this.isCircle,
    required this.hand,
    required this.secondsMarker,
    required this.handSize,
    required this.start,
    required this.end,
    required this.highlightStart,
    required this.highlightEnd,
    required this.eventObservable,
    required this.widthCircle,
    Key? key,
  }) : super(key: key);

  @override
  _GaugeWidgetState createState() => _GaugeWidgetState();
}

class _GaugeWidgetState extends State<GaugeWidget>
    with TickerProviderStateMixin {
  double val = 0.0;
  double? newVal;
  late final AnimationController percentageAnimationController;
  late final StreamSubscription<double> subscription;

  @override
  void initState() {
    percentageAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..addListener(() {
        setState(() {
          val =
              lerpDouble(val, newVal, percentageAnimationController.value) ?? 0;
        });
      });
    subscription = widget.eventObservable.listen((value) {
      (value >= widget.end)
          ? reloadData(widget.end.toDouble())
          : reloadData(value);
    });
    super.initState();
  }

  @override
  void dispose() {
    percentageAnimationController.dispose();
    super.dispose();
  }

  reloadData(double value) {
    newVal = value;
    percentageAnimationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (_, constraints) => Container(
          height: widget.width,
          width: widget.width,
          alignment: Alignment.center,
          child: Stack(
            fit: StackFit.expand,
            children: [
              widget.isCircle == true
                  ? Container(
                      height: constraints.maxWidth,
                      width: constraints.maxWidth,
                      padding: EdgeInsets.all(widget.widthCircle),
                      child: CustomPaint(
                        foregroundPainter: LinePainter(
                          lineColor: widget.backgroundColor,
                          completeColor: widget.circleColor,
                          startValue: widget.start,
                          endValue: widget.end,
                          startPercent: widget.highlightStart,
                          endPercent: widget.highlightEnd,
                          width: widget.widthCircle,
                          value: val,
                        ),
                      ),
                    )
                  : const SizedBox(),
              widget.hand == Hand.none || widget.hand == Hand.short
                  ? const SizedBox()
                  : Center(
                      child: Container(
                        width: widget.handSize,
                        height: widget.handSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.indicatorColor,
                        ),
                      ),
                    ),
              Container(
                height: constraints.maxWidth,
                width: constraints.maxWidth,
                // alignment: Alignment.center,
                padding: EdgeInsets.only(
                  top: widget.hand == Hand.short
                      ? widget.widthCircle
                      : widget.widthCircle,
                  bottom: widget.widthCircle,
                  right: widget.widthCircle,
                  left: widget.widthCircle,
                ),
                child: CustomPaint(
                  painter: GaugeTextPainter(
                    numberInAndOut: widget.numberInAndOut,
                    secondsMarker: widget.secondsMarker,
                    number: widget.number,
                    inactiveColor: widget.inactiveColor,
                    activeColor: widget.activeColor,
                    start: widget.start,
                    end: widget.end,
                    value: val,
                    widthCircle: widget.widthCircle,
                    textStyle: widget.textStyle,
                  ),
                ),
              ),
              widget.hand != Hand.none
                  ? Center(
                      child: Container(
                        height: constraints.maxWidth,
                        width: constraints.maxWidth,
                        padding: EdgeInsets.all(widget.hand == Hand.short
                            ? widget.widthCircle / 1.5
                            : widget.paddingHand),
                        child: CustomPaint(
                          painter: HandPainter(
                            shadowHand: widget.shadowHand,
                            hand: widget.hand,
                            value: val,
                            start: widget.start,
                            end: widget.end,
                            color: widget.handColor,
                            handSize: widget.handSize,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
              Container(
                child: widget.counterAlign != CounterAlign.none
                    ? CustomPaint(
                        painter: GaugeTextCounter(
                          isDecimal: widget.isDecimal,
                          start: widget.start,
                          width: widget.widthCircle,
                          counterAlign: widget.counterAlign,
                          end: widget.end,
                          value: val,
                          textStyle: widget.counterStyle,
                        ),
                      )
                    : const SizedBox(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
