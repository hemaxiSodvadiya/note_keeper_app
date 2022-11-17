import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_keeper_app/common/note_Card.dart';
import 'package:note_keeper_app/helper/helper.dart';

import '../common/add_note.dart';
import '../common/color.dart';
import '../common/edit_note.dart';
import '../global/global.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static TextEditingController titleController = TextEditingController();
  static TextEditingController contextController = TextEditingController();

  int color_id = Random().nextInt(Style.cardsColor.length);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.mainColor,
      appBar: AppBar(
        title: Text(
          "Note Keeper",
          style: GoogleFonts.roboto(
              color: Color(0xffccebc0),
              fontWeight: FontWeight.bold,
              fontSize: 26),
        ),
        centerTitle: true,
        backgroundColor: Style.mainColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your recent Notes",
              style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    CloudFirestoreHelper.cloudFirestoreHelper.selectRecord(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    QuerySnapshot? data = snapshot.data;
                    List<QueryDocumentSnapshot> list = data!.docs;
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        return Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.green.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${list[i]['note_title']}",
                                style: Style.mainTitle,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "${list[i]['note_context']}",
                                style: Style.mainContext,
                              ),
                              Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      await CloudFirestoreHelper
                                          .cloudFirestoreHelper
                                          .deleteRecord(id: list[i].id);
                                    },
                                    icon: Icon(Icons.delete_outline_rounded),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      //await CloudFirestoreHelper.cloudFirestoreHelper.updateRecord(id: list[i].id, updateData: updateData())
                                      updateData(id: list[i].id);
                                    },
                                    icon: Icon(Icons.edit),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );

                      },
                      itemCount: list.length,
                    );
                  }
                  return Text(
                    "There is no Notes",
                    style: GoogleFonts.nunito(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Style.accentColor,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => EditNote()));
        },
        label: Text("Add Note"),
        icon: Icon(Icons.add),
      ),
    );
  }

  updateData({required String id}) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Center(
                  child: Text("Update"),
                ),
                TextFormField(
                  controller: titleController,
                  onSaved: (val) {
                    Global.title = val!;
                  },
                  validator: (val) {
                    (val!.isEmpty) ? 'Enter your title first...' : null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Title",
                    label: Text("Enter Your title"),
                  ),
                ),
                TextFormField(
                  controller: contextController,
                  onSaved: (val) {
                    Global.context = val!;
                  },
                  validator: (val) {
                    (val!.isEmpty) ? 'Enter your context first' : null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Context",
                    label: Text("Enter Your context"),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();

                          Map<String, dynamic> update = {
                            'note_title': Global.title,
                            'note_context': Global.context,
                          };

                          CloudFirestoreHelper.cloudFirestoreHelper
                              .updateRecord(id: id, updateData: update);

                          titleController.clear();
                          contextController.clear();

                          setState(() {
                            Global.title = "";
                            Global.context = "";
                          });
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text("Update"),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        titleController.clear();
                        contextController.clear();

                        setState(() {
                          Global.title = "";
                          Global.context = "";
                        });
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancel"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
