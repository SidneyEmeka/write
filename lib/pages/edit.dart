import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../provider/dbprovider.dart';

class Edit extends StatefulWidget {
  final int theWriteId;
  final String theWriteContent;
  const Edit({super.key, required this.theWriteId, required this.theWriteContent});

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  //initializing a database instance
  final Dbproviders mydbprovider = Dbproviders.instance;
  String? userEditContent;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("EDIT"), Icon(FontAwesomeIcons.pagelines)],
        ),
      ),
      body:   Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black)),
            height: 35,
            width: MediaQuery.of(context).size.width / 1.7,
            child: TextFormField(
              key: Key(widget.theWriteContent),
              initialValue: widget.theWriteContent,
              onChanged: (value){
               setState(() {
                 userEditContent = value;
               });
              },
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                  hintStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w400,
                      fontSize: 12),
                  hintText: "Wanna 'rite' something?",
                  border:
                  OutlineInputBorder(borderSide: BorderSide.none)),
            ),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade900,
                  foregroundColor: Colors.white),
              onPressed: () {
                if (userEditContent == null || userEditContent == "") return;
                mydbprovider.editAWrite(id: widget.theWriteId, newContent: userEditContent!);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.brown.shade700,
                  content: const Align(
                      alignment: Alignment.center,
                      child: Text("Rite Added Successfully",
                          style: TextStyle(
                              color: Colors.white, fontSize: 12))),
                  duration: const Duration(seconds: 1),
                ));
              },
              child: const Text("Save"))
        ],
      ),
    );
  }
}
