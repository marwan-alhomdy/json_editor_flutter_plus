import 'package:flutter/material.dart';

class SyntaxErrorWidget extends StatelessWidget {
  const SyntaxErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      padding: const EdgeInsets.all(5),
      child: const Row(
        children: [
          Text('Syntax Error', style: TextStyle(color: Colors.white)),
          SizedBox(width: 5),
          Icon(Icons.dangerous, color: Colors.white),
        ],
      ),
    );
  }
}
