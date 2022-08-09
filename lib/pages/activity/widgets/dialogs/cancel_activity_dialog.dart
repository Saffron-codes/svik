import 'package:flutter/material.dart';

class CancelActivityDialog extends StatefulWidget {
  const CancelActivityDialog({ Key? key }) : super(key: key);

  @override
  State<CancelActivityDialog> createState() => _CancelActivityDialogState();
}

class _CancelActivityDialogState extends State<CancelActivityDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromARGB(255, 55, 50, 50),
      // title: Text("Cancel Activity"),
      title: Text("Are you sure ?",style: TextStyle(color: Colors.white),),
      actions: [
        TextButton(onPressed: (){}, child: Text("Yes")),
        TextButton(onPressed: (){}, child: Text("No")),

      ],
      actionsAlignment: MainAxisAlignment.spaceAround,
    );
  }
}