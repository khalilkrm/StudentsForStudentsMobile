import 'package:flutter/material.dart';

class ScreenContent extends StatelessWidget {
  final List<Widget> _children;

  const ScreenContent({required List<Widget> children, super.key})
      : _children = children;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            ..._children,
          ],
        ),
      ),
    );
  }
}
