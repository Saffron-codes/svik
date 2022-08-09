import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DoneButton extends StatefulWidget {
  const DoneButton({ Key? key }) : super(key: key);

  @override
  State<DoneButton> createState() => _DoneButtonState();
}

class _DoneButtonState extends State<DoneButton> {
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: (){},
      child: Icon(Icons.done),
    );
  }
}