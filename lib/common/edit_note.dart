import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note_keeper_app/common/color.dart';

class EditNote extends StatefulWidget {
  const EditNote({Key? key}) : super(key: key);

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  int color_id = Random().nextInt(Style.cardsColor.length);

  TextEditingController titleController = TextEditingController();
  TextEditingController contextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.cardsColor[color_id],
      appBar: AppBar(
        backgroundColor: Style.cardsColor[color_id],
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Add a new Note",
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Note Title',
              ),
              style: Style.mainTitle,
            ),
            TextField(
              controller: contextController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Note Context',
              ),
              style: Style.mainContext,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Style.accentColor,
        onPressed: () {
          FirebaseFirestore.instance.collection("notes").add({
            "note_title": titleController.text,
            "note_context": contextController.text,
            "color_id": color_id,
          }).then((value) {
            print(value.id);
            Navigator.of(context).pop();
          }).catchError((error) => print("Failed to add new $error"));
        },
        child: Icon(Icons.save_rounded),
      ),
    );
  }
}
