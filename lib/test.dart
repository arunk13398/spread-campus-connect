import 'package:flutter/cupertino.dart';

class TestDemo extends StatefulWidget {
  const TestDemo({Key? key}) : super(key: key);

  @override
  State<TestDemo> createState() => _TestDemoState();
}

class _TestDemoState extends State<TestDemo> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
        child:Text("Text demo"),
    ));
  }
}
