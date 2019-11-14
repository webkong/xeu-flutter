import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('学源'),
      ),
      body: Center(
        child: Table(
          children: <TableRow>[
            TableRow(
              children: <Widget>[
                Center(
                  child: GestureDetector(
                    child: Container(
                      width: 150.0,
                      height: 250.0,
                      child: Text('成长记录'),
                    ),
                    onTap: () => Navigator.pushNamed(context, '/signup'),
                  ),
                ),Center(
                  child: GestureDetector(
                    child: Container(
                      child: Text('成长记录'),
                    ),
                    onTap: () => Navigator.pushNamed(context, '/signup'),
                  ),
                )
              ],
            ),
            TableRow(
              children: <Widget>[
                Center(
                  child: GestureDetector(
                    child: Container(
                      child: Text('成长记录'),
                    ),
                    onTap: () => Navigator.pushNamed(context, '/signup'),
                  ),
                ),Center(
                  child: GestureDetector(
                    child: Container(
                      child: Text('成长记录'),
                    ),
                    onTap: () => Navigator.pushNamed(context, '/signup'),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
