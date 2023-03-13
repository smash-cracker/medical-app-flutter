import 'dart:math' as math;
import 'package:flutter/material.dart';

class SemiCircularSlider extends StatefulWidget {
  final double minValue;
  final double maxValue;
  final double initialValue;
  final ValueChanged<double>? onChanged;

  SemiCircularSlider({
    required this.minValue,
    required this.maxValue,
    required this.initialValue,
    this.onChanged,
  });

  @override
  _SemiCircularSliderState createState() => _SemiCircularSliderState();
}

class _SemiCircularSliderState extends State<SemiCircularSlider> {
  double _value = 0.0;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RotatedBox(
        quarterTurns: 2,
        child: Slider(
          min: widget.minValue,
          max: widget.maxValue,
          value: _value,
          onChanged: (double value) {
            setState(() {
              _value = value;
              widget.onChanged?.call(value);
            });
          },
          activeColor: Colors.green,
          inactiveColor: Colors.grey[300],
          label: '$_value',
          divisions: ((widget.maxValue - widget.minValue) / 10).round(),
        ),
      ),
    );
  }
}
