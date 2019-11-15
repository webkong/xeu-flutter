import 'package:flutter/material.dart';
import '../utils/toast.dart';

class NewRecord extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NewRecord();
  }
}

class _NewRecord extends State<NewRecord> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[],
      ),
      body: Text('new record'),
    );
  }
}
