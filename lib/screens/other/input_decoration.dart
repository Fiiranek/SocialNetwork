import 'package:flutter/material.dart';

  TextStyle signUpTitle = TextStyle(color: Colors.white, fontSize: 26,fontWeight: FontWeight.w600);

  InputDecoration signUpInputDecoration = InputDecoration(
    
    filled: true,
    errorBorder: OutlineInputBorder(borderSide: BorderSide(color:Color(0xff820000)),borderRadius: BorderRadius.circular(50)),
    fillColor: Colors.white,
    focusedBorder: OutlineInputBorder(borderRadius:
      BorderRadius.circular(50),
      borderSide: BorderSide(color: Color(0xff820000)),
      
    ),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color:Color(0xff820000)),borderRadius: BorderRadius.circular(50)),
      
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      );

TextStyle inputTextStyle = TextStyle(
  color: Color(0xff820000)
);

TextStyle createAccountText = TextStyle(
  fontSize: 16
);

InputDecoration addPostInputDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide.none
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide.none
  )
);
  
  