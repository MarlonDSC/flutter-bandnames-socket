import 'dart:io';

import 'package:band_names/models/band.dart';
import 'package:band_names/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('active-bands', _handleActiveBand);
    super.initState();
  }

  void _handleActiveBand(dynamic payload) {
    bands = (payload as List).map((e) => Band.fromMap(e)).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('BandNames'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: socketService.serverStatus == ServerStatus.online
                ? const Icon(
                    Icons.check_circle,
                    color: Colors.blue,
                  )
                : const Icon(
                    Icons.offline_bolt,
                    color: Colors.red,
                  ),
          ),
        ],
        // backgroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          _showGraph(),
          ListView.builder(
            itemCount: bands.length,
            shrinkWrap: true,
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
                  onTap: () {
                    socketService.socket.emit('vote-band', {'id': bands[index].id});
                  },
                ),
                onDismissed: (direction) {
                  final socketService =
                      Provider.of<SocketService>(context, listen: false);
                  socketService.socket.emit('delete-band', {'id': bands[index].id});
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> addNewBand() async {
    TextEditingController textEditingController = TextEditingController();

    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('New band name'),
            content: TextField(
              controller: textEditingController,
            ),
            actions: [
              TextButton(
                onPressed: () => addBandToList(textEditingController.text),
                child: const Text('ADD'),
              ),
            ],
          );
        },
      );
    } else {
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
    }
  }

  void addBandToList(String name) {
    if (name.isNotEmpty) {
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.socket.emit('add-band', {'name': name});
      // bands.add(
      //   Band(
      //     id: bands.length.toString(),
      //     name: name,
      //     votes: 0,
      //   ),
      // );
      // setState(() {});
    }
    Navigator.pop(context);
  }

  Widget _showGraph() {
    Map<String, double> dataMap = new Map();

    bands.forEach((element) {
      dataMap.putIfAbsent(element.name, () => element.votes.toDouble());
    },);
    // Map<String, double> dataMap = {
    //   "Flutter": 5,
    //   "React": 3,
    //   "Xamarin": 2,
    //   "Ionic": 2,
    // };

    return SizedBox(
        width: double.infinity,
        height: 200,
        child: PieChart(
          dataMap: dataMap,
        ));
  }
}
