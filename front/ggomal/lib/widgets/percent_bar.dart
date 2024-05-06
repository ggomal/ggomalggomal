import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class PercentBar extends StatefulWidget {

  final Map<String, dynamic> percentData;
  const PercentBar(this.percentData, {super.key});

  @override
  State<PercentBar> createState() => _PercentBarState();
}

class _PercentBarState extends State<PercentBar> {


  @override
  Widget build(BuildContext context) {

    return Row(
      children: [

        LinearPercentIndicator(
          width: MediaQuery.of(context).size.width / 2 - 300,
          lineHeight: 40.0,
          percent: (widget.percentData['count'] < 10 ? widget.percentData['count']: 10) / 10,
          animation: true,
          animationDuration: 500,
          animateFromLastPercent: true,
          center: Text(
            "${widget.percentData['count'] < 10 ? widget.percentData['count']: 10 } / 10",
            style: TextStyle(
              fontFamily: 'Maplestory',
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          barRadius: const Radius.circular(16),
          progressColor: widget.percentData['barColor'],
        ),
        Image.asset(
          widget.percentData['imgUrl'],
          width: 60,
          height: 50,
        ),
      ],
    );
  }
}
