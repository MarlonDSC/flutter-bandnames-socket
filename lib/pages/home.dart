import 'dart:io';

import 'package:band_names/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Metallica', votes: 5),
    Band(id: '2', name: 'Heroes del silencio', votes: 1),
    Band(id: '3', name: 'Queen', votes: 2),
    Band(id: '4', name: 'Bon Jovi', votes: 5),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BandNames'),
        // backgroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(bands[index].id),
            direction: DismissDirection.startToEnd,
            background: Container(
              padding: const EdgeInsets.only(left: 8),
              color: Colors.red,
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Delete Band',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue[100],
                child: Text(
                  bands[index].name.substring(0, 2),
                ),
              ),
              title: Text(bands[index].name),
              trailing: Text(
                bands[index].votes.toString(),
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              onTap: () {},
            ),
            onDismissed: (direction) {},
          );
        },
      ),
    );
  }

  Future<void> addNewBand() async {
    TextEditingController textEditingController = TextEditingController();

    // if (Platform.isAndroid) {
    //   return showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertDialog(
    //         title: const Text('New band name'),
    //         content: TextField(
    //           controller: textEditingController,
    //         ),
    //         actions: [
    //           TextButton(
    //             onPressed: () => addBandToList(textEditingController.text),
    //             child: const Text('ADD'),
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // } else {
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('New band name:'),
          content: CupertinoTextField(controller: textEditingController),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text('Add'),
              onPressed: () {
                addBandToList(textEditingController.text);
              },
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text('Dismiss'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
    // }
  }

  void addBandToList(String name) {
    if (name.isNotEmpty) {
      bands.add(
        Band(
          id: bands.length.toString(),
          name: name,
          votes: 0,
        ),
      );
      setState(() {});
    }
    Navigator.pop(context);
  }
}
