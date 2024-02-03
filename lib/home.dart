import 'package:flutter/material.dart';
import 'package:flutter_application_1/widget/position_widget.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: const PositionWidget(),
    );
  }
}