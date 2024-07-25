import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:write/pages/edit.dart';
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
  String? userDescribed;
  final contentDeescController = TextEditingController();

  //LIST TILE
  Widget aWriteTile(
      {required int id,
      required String content,
      required String description,
      required int isDone}) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: ((context) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Edit(
                    theWriteId: id,
                    theWriteContent: content,
                    theWriteContentDescription: description,
                  ),
                ),
              );
            }),
            icon: FontAwesomeIcons.penToSquare,
            backgroundColor: Colors.brown.shade700,
            borderRadius: BorderRadius.circular(10),
            autoClose: true,
            padding: EdgeInsets.zero,
          ),
        ],
      ),
      child: Container(
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
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  //alignment: Alignment.center,
                  height: 50,
                  decoration: const BoxDecoration(
                      //border: Border.all(color: Colors.white)
                      ),
                  child: Text(
                    description,
                    style: const TextStyle(
                        color: Colors.white,
                        overflow: TextOverflow.fade,
                        fontSize: 12),
                  ),
                ),
                const Text(
                  "...Tap to read more",
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 10,
                      color: Colors.white),
                )
              ],
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
      ),
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
                      final aWriteDescription = aWrite.userContentDescription;
                      return aWriteTile(
                          content: aWriteontent,
                          isDone: aWriteStatus,
                          id: aWriteId,
                          description: aWriteDescription);
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
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black)),
                          height: 50,
                          width: MediaQuery.of(context).size.width / 1.7,
                          child: TextField(
                            //maxLines: 2,
                            controller: contentController,
                            cursorColor: Colors.transparent,
                            decoration: const InputDecoration(
                                hintStyle: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12),
                                hintText: "Title",
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none)),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black)),
                          height: MediaQuery.of(context).size.height/ 1.7,
                          width: MediaQuery.of(context).size.width / 1.7,
                          child: TextField(
                            maxLines: null,
                            controller: contentDeescController,
                            cursorColor: Colors.transparent,
                            decoration: const InputDecoration(
                    
                                hintStyle: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12),
                                hintText: "Description",
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple.shade900,
                            foregroundColor: Colors.white),
                        onPressed: () {
                          setState(() {
                            userWrote = contentController.text;
                            userDescribed = contentDeescController.text;
                            contentDeescController.text = "";
                            contentController.text = "";
                          });
                          if (userWrote == null || userWrote == "") return;
                          mydbprovider.addRite(
                              content: userWrote!, description: userDescribed!);
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
