import 'package:flutter/material.dart'; 
class Palette { 
  static const MaterialColor kToDark = MaterialColor( 
    0xff243447, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch. 
     <int, Color>{ 
      50:    Color(0xffeceff1),//10% 
      100:   Color(0xffcfd8dc),//20% 
      200:  Color(0xffb0bec5),//30% 
      300:  Color(0xff90a4ae),//40% 
      400:  Color(0xff78909c),//50% 
      500:  Color(0xff607d8b),//60% 
      600:  Color(0xff546e7a),//70% 
      700:  Color(0xff455a64),//80% 
      800:  Color(0xff37474f),//90% 
      900:  Color(0xff000000),//100% 
    }, 
  ); 
} 