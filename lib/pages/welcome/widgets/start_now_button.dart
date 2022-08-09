import 'package:chatapp/config/theme/theme_constants.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StartNowButton extends StatelessWidget {
  const StartNowButton({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 55,
      child: CupertinoButton(
        borderRadius: BorderRadius.circular(28),
        onPressed: ()=>Navigator.pushNamed(context, '/login'),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const[
            Text("Start Now",style: TextStyle(color: Colors.white),),
            SizedBox(width: 10,),
            // Icon(Icons.arrow_forward)
          ],
        ),
        color:Color.fromARGB(255, 1, 1, 254)
      ),
    );
  }
}