import 'package:flutter/material.dart';

const kTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
const kSmallTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 14,
  fontFamily: 'Inter',
  fontWeight: FontWeight.w500,
);
const kBigTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 28,
  fontFamily: 'Inter',
  fontWeight: FontWeight.w700,
  height: 0,
);
const kMidTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 16,
  fontFamily: 'Inter',
  fontWeight: FontWeight.w500,
  height: 0,
);
