import 'package:flutter/material.dart';

class ListCard extends StatelessWidget {
  final Color? color;
  final Widget? cardchild;
  final void Function()? onPress;
  const ListCard({super.key, this.color, this.cardchild, this.onPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(),
    );
  }
}
