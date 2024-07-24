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
    return Dismissible(
      key: ValueKey<int>(id),
      onDismissed: (direction) {
        mydbprovider.deleteAwrite(id: id);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.grey,
          content: Align(
              alignment: Alignment.center,
              child: Text("Write Deleted",
                  style: TextStyle(color: Colors.white, fontSize: 12))),
          duration: Duration(seconds: 1),
        ));
      },
      background: Container(
        decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white)),
       // margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.centerLeft,
        child: const Text(
          "Delete",
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
      secondaryBackground: Container(
        decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white)),
       // margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.centerRight,
        child: const Text(
          "Delete",
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey)),
          color: Colors.white,
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 5),
          leading: Text(
            content,
            style: isDone == 1
                ? const TextStyle(
                    decoration: TextDecoration.lineThrough, color: Colors.grey)
                : const TextStyle(decoration: TextDecoration.none),
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
                    color: Colors.red,
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
                ),
        ),
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
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(10)),
          height: MediaQuery.of(context).size.height / 1.3,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
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
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      ),
                    ),
                    //SizedBox(width: 10,),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          userWrote = contentController.text;
                          contentController.text = "";
                        });
                        if (userWrote == null || userWrote == "") return;
                        mydbprovider.addRite(content: userWrote!);
                      },
                      child: const Text(
                        "Add",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              FutureBuilder(
                future: mydbprovider.getAllWrites(),
                builder: (context, snapshot) {
                  if (snapshot.hasError || snapshot.data == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white)),
                     height: MediaQuery.of(context).size.height / 1.7,
                    child: SingleChildScrollView(
                      child: Column(
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
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
