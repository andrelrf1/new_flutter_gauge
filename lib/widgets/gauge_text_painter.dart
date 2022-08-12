import 'dart:math';
import 'package:flutter/material.dart';
import 'package:new_flutter_gauge/new_flutter_gauge.dart';

class GaugeTextPainter extends CustomPainter {
  final hourTickMarkLength = 30.0;
  final minuteTickMarkLength = 0.0;
  final hourTickMarkWidth = 1.5;
  final minuteTickMarkWidth = 1.0;
  final Paint tickPaint;
  final TextPainter textPainter;
  final TextStyle? textStyle;

  final int end;
  final int start;
  final double value;
  final double widthCircle;
  final Number number;
  final SecondsMarker secondsMarker;
  final NumberInAndOut numberInAndOut;
  final Color inactiveColor;
  final Color activeColor;

  GaugeTextPainter({
    required this.inactiveColor,
    required this.activeColor,
    required this.numberInAndOut,
    required this.widthCircle,
    required this.secondsMarker,
    required this.start,
    required this.end,
    required this.value,
    required this.textStyle,
    required this.number,
  })  : tickPaint = Paint(),
        textPainter = TextPainter(
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
        ) {
    tickPaint.color = activeColor;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double tickMarkLength;
    final double angle = ((2 / 3) * 2) * pi / end;
    final double radius = (size.width / 2);
    canvas.save();
    // drawing
    canvas.translate(radius, radius);
    canvas.rotate(-2.1);
    for (var i = 0; i <= end; i++) {
      // make the length and stroke of the tick marker longer and thicker depending
      tickMarkLength = i % 5 == 0
          ? hourTickMarkLength
          : secondsMarker != SecondsMarker.seconds
              ? minuteTickMarkLength
              : hourTickMarkLength;
      tickPaint.strokeWidth = i % 5 == 0
          ? hourTickMarkWidth
          : secondsMarker != SecondsMarker.seconds
              ? minuteTickMarkLength
              : hourTickMarkWidth;

      if (value.toInt() == i) tickPaint.color = inactiveColor;

      //seconds & minutes
      if (i != 0 && i != end) {
        if (secondsMarker == SecondsMarker.all) {
          canvas.drawLine(Offset(0.0, -radius - 21),
              Offset(0.0, -radius - 15 + tickMarkLength), tickPaint);
        } else if (secondsMarker == SecondsMarker.minutes) {
          if (i % 5 == 0) {
            canvas.drawLine(Offset(0.0, -radius - 10),
                Offset(0.0, -radius - 15 + tickMarkLength), tickPaint);
          }
        } else if (secondsMarker == SecondsMarker.secondsAndMinute) {
          if (i % 5 == 0) {
            canvas.drawLine(Offset(0.0, -radius + 20),
                Offset(0.0, -radius + 12), tickPaint);
          } else {
            canvas.drawLine(Offset(0.0, -radius + 18),
                Offset(0.0, -radius + 12), tickPaint);
          }
        } else if (secondsMarker == SecondsMarker.seconds) {
          canvas.drawLine(Offset(0.0, -radius - widthCircle / 2),
              Offset(0.0, -radius + widthCircle / 2), tickPaint);
        }
      }

      //draw the text
      if (i % (end < 100 ? 5 : 10) == 0 || i == end) {
        String label = i.toString();
        canvas.save();
        if (numberInAndOut == NumberInAndOut.inside) {
          canvas.translate(i == 40 ? -0.0 : 0.0, -radius + (widthCircle * 2));
        } else {
          canvas.translate(i == 40 ? -0.0 : 0.0, -radius - (0));
        }

        textPainter.text = TextSpan(
          text: label,
          style: textStyle ?? const TextStyle(color: Colors.black),
        );

        //helps make the text painted vertically
        canvas.rotate(-angle * i + 2.1);
        textPainter.layout();
        if (number == Number.all) {
          textPainter.paint(canvas,
              Offset(-(textPainter.width / 2), -(textPainter.height / 1.5)));
        } else if (number == Number.endAndStart) {
          if (i == 0 || i == end) {
            textPainter.paint(canvas,
                Offset(-(textPainter.width / 2), -(textPainter.height / 2)));
          }
        } else if (number == Number.endAndCenterAndStart) {
          if (i == 0 || i == end || i == end ~/ 2) {
            textPainter.paint(canvas,
                Offset(-(textPainter.width / 2), -(textPainter.height / 1.5)));
          }
        }
        canvas.restore();
      }

      canvas.rotate(angle);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(GaugeTextPainter oldDelegate) => false;
}

///counter text bottom
class GaugeTextCounter extends CustomPainter {
  final double hourTickMarkLength = 30.0;
  final double minuteTickMarkLength = 0.0;
  final double hourTickMarkWidth = 1.5;
  final double minuteTickMarkWidth = 1.0;
  final Paint tickPaint;
  final TextPainter textPainter;
  final TextStyle? textStyle;

  final int end;
  final int start;
  final double value;
  final CounterAlign counterAlign;
  final double width;
  final bool isDecimal;

  GaugeTextCounter({
    required this.isDecimal,
    required this.width,
    required this.counterAlign,
    required this.start,
    required this.end,
    required this.value,
    required this.textStyle,
  })  : tickPaint = Paint(),
        textPainter = TextPainter(
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
        ) {
    tickPaint.color = Colors.green;
  }

  @override
  void paint(Canvas canvas, Size size) {
    const double angle = 2 * pi / 60;
    final double radius = size.width / 2;
    canvas.save();
    canvas.translate(radius, radius);
    for (var i = 0; i <= 60; i++) {
      if (i == 30) {
        String label;

        if (isDecimal == true) {
          label = value.toStringAsFixed(1);
        } else {
          label = (value.toInt()).toString();
        }

        canvas.save();

        if (counterAlign == CounterAlign.bottom) {
          canvas.translate(0.0, -radius + (60));
        } else if (counterAlign == CounterAlign.top) {
          canvas.translate(0.0, radius - (40));
        }

        textPainter.text = TextSpan(
          text: label,
          style: textStyle ?? const TextStyle(color: Colors.black),
        );
        canvas.rotate(-angle * i);

        textPainter.layout();

        textPainter.paint(
            canvas,
            Offset(-(textPainter.width / 2),
                counterAlign == CounterAlign.center ? -width : 0));

        canvas.restore();
      }

      canvas.rotate(angle);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(GaugeTextCounter oldDelegate) => false;
}
