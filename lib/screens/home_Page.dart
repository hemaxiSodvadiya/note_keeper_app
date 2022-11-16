import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_keeper_app/common/note_Card.dart';

import '../common/add_note.dart';
import '../common/color.dart';
import '../common/edit_note.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                    FirebaseFirestore.instance.collection("notes").snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    return GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      children: snapshot.data!.docs
                          .map((note) => noteCard(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddNote(note),
                                  ),
                                );
                              }, note))
                          .toList(),
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
}
