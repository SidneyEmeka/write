import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:write/provider/dbprovider.dart';

import '../models/writesmodel.dart';

class Allritespage extends StatefulWidget {
  const Allritespage({super.key});

  @override
  State<Allritespage> createState() => _AllritespageState();
}

class _AllritespageState extends State<Allritespage> {
  @override
  void initState() {
    super.initState();
    mydbprovider.getAllWrites();
  }

  //initializing a database instance
  final Dbproviders mydbprovider = Dbproviders.instance;

  //USER INPUTS
  String? userWrote;
  final contentController = TextEditingController();

  //LIST TILE
  Widget aWriteTile(
      {required int id, required String content, required int isDone}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: const Border(bottom: BorderSide(color: Colors.grey)),
        color: Colors.purple.shade900,
      ),
      child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: IconButton(
              onPressed: () {
                mydbprovider.deleteAwrite(id: id);
                setState(() {});
              },
              icon: const Icon(
                FontAwesomeIcons.trash,
                size: 15,
                color: Colors.white,
              )),
          title: Text(
            content.toUpperCase(),
            style: isDone == 1
                ? const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    decorationThickness: 3,
                    decorationColor: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: Colors.white)
                : const TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
          ),
          trailing: isDone == 0
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isDone = 1;
                    });
                    mydbprovider.updateAWrite(id: id, isdone: isDone);
                  },
                  icon: const Icon(
                    FontAwesomeIcons.circle,
                    color: Colors.white,
                    size: 15,
                  ),
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      isDone = 0;
                    });
                    mydbprovider.updateAWrite(id: id, isdone: isDone);
                  },
                  icon: const Icon(
                    FontAwesomeIcons.circleCheck,
                    color: Colors.green,
                    size: 15,
                  ),
                )),
    );
  }

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
          children: [Text("RITE"), Icon(FontAwesomeIcons.pagelines)],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            FutureBuilder(
              future: mydbprovider.getAllWrites(),
              builder: (context, snapshot) {
                if (snapshot.hasError || snapshot.data == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //therites
                    ...snapshot.data!.map((aWrite) {
                      final aWriteontent = aWrite.userContent;
                      final aWriteStatus = aWrite.userIsDone;
                      final aWriteId = aWrite.userWroteID;
                      return aWriteTile(
                          content: aWriteontent,
                          isDone: aWriteStatus,
                          id: aWriteId);
                    })
                  ],
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown.shade700,
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: const Text(
                    "What's on your mind",
                    textAlign: TextAlign.center,
                  ),
                  content: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black)),
                    height: 35,
                    width: MediaQuery.of(context).size.width / 1.7,
                    child: TextField(
                      controller: contentController,
                      cursorColor: Colors.transparent,
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
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            userWrote = contentController.text;
                            contentController.text = "";
                          });
                          if (userWrote == null || userWrote == "") return;
                          mydbprovider.addRite(content: userWrote!);
                        },
                        child: const Text("Save"))
                  ],
                );
              });
        },
        child: const Icon(
          FontAwesomeIcons.penNib,
          size: 15,
          color: Colors.white,
        ),
      ),
    );
  }
}
