import 'package:flutter/material.dart';
import 'package:flutter_application_1/widget/position_widget.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 500,
      width: 300,
      child: PositionWidget(),
    );
  }
}