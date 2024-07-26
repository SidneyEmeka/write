import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:write/pages/home.dart';

import '../provider/dbprovider.dart';

class Edit extends StatefulWidget {
  final int theWriteId;
  final String theWriteContent;
  final String theWriteContentDescription;

  const Edit(
      {super.key,
      required this.theWriteId,
      required this.theWriteContent,
      required this.theWriteContentDescription});

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  //initializing a database instance
  final Dbproviders mydbprovider = Dbproviders.instance;
  String? userEditContent;
  String? userEditContentDescription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 40,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: const Text(""),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "EDIT",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.brown.shade900,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Icon(
              FontAwesomeIcons.penToSquare,
              color: Colors.brown.shade900,
              size: 15,
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          height: MediaQuery.of(context).size.height / 1.2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                cursorColor: Colors.purple.shade900,
                cursorHeight: 20,
                maxLines: null,
                key: Key(widget.theWriteContent),
                initialValue: widget.theWriteContent,
                onChanged: (value) {
                  setState(() {
                    userEditContent = value;
                  });
                },
                decoration: const InputDecoration(
                    hintStyle: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w400,
                        fontSize: 12),
                    hintText: "Wanna 'rite' something new?",
                    border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height/1.4,
                child: SingleChildScrollView(
                  child: TextFormField(
                    cursorColor: Colors.purple.shade900,
                    cursorHeight: 20,
                    maxLines: null,
                    key: Key(widget.theWriteContentDescription),
                    initialValue: widget.theWriteContentDescription,
                    onChanged: (value) {
                      setState(() {
                        userEditContentDescription = value;
                      });
                    },
                    decoration: const InputDecoration(
                        hintStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w400,
                            fontSize: 12),
                        hintText: "Wanna 'rite' something new?",
                        border: OutlineInputBorder()),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown.shade700,
        onPressed: () {
          if (userEditContent == null || userEditContent == "") {
            return;
          }
          mydbprovider.editAWrite(
              id: widget.theWriteId,
              newContent: userEditContent!,
              newDescription: userEditContentDescription!);
          // Navigator.pop(context);
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const Allritespage()),
          );
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.brown.shade700,
            content: const Align(
                alignment: Alignment.center,
                child: Text("Rite Added Successfully",
                    style: TextStyle(color: Colors.white, fontSize: 12))),
            duration: const Duration(seconds: 1),
          ));
        },
        child: const Icon(
          FontAwesomeIcons.floppyDisk,
          size: 15,
          color: Colors.white,
        ),
      ),
    );
  }
}
