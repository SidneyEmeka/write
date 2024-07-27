import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Read extends StatefulWidget {
  final String title;
  final String description;

  const Read({super.key, required this.title, required this.description});

  @override
  State<Read> createState() => _ReadState();
}

class _ReadState extends State<Read> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 40,
        centerTitle: true,
        leading: const Text(""),
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.brown.shade900,
              ),
            ),
            SizedBox(width: 5,),
            Icon(
              FontAwesomeIcons.bookOpen,
              color: Colors.brown.shade900,
              size: 15,
            )
          ],
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height / 1.2,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Text(
                widget.description,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  color: Colors.brown.shade900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
