import 'package:flutter/material.dart';

BoxDecoration signInDecoration = BoxDecoration(
                image: DecorationImage(image: ExactAssetImage('assets/bckg.png',),fit: BoxFit.cover)
              );

BoxDecoration signInButtonDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.all(Radius.circular(50)),
  border: Border.all(color:Color(0xff820000))
);

TextStyle signInButtonText = TextStyle(
  color: Color(0xff820000),
  fontSize: 22
);