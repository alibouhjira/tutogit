import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Setlike extends StatefulWidget {
  const Setlike({Key? key, required this.isliked}) : super(key: key);
   final String isliked;

  @override
  State<Setlike> createState() => _SetlikeState();
}

class _SetlikeState extends State<Setlike> {
  @override
  Widget build(BuildContext context) {
    if (widget.isliked=="true"){
      return Icon(Icons.favorite,color: Colors.pink,size:40);
    }
    else return Icon(Icons.favorite_border,size:40);
  }
}
