import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    Key? key,
    required this.icon,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          // minimumSize: const Size.fromHeight(50),
        ),
        child: buildContent(context),
        onPressed: onClicked,
      );

  Widget buildContent(BuildContext context) => Row(
        children: [
          Icon(icon, size:20),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(fontSize: MediaQuery.of(context).size.width/24, color: Colors.white),
          ),
        ],
      );
}