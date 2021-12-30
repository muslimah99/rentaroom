import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rentaroom/room.dart';
import 'package:rentaroom/detailpage.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List roomlist = [];
  String titlecenter = "Loading data...";
  late double screenHeight, screenWidth, resWidth;
  late ScrollController _scrollController;
  int scrollcount = 10;
  int rowcount = 2;
  int numroom = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _loadRooms();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      rowcount = 3;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rent A Room'),
      ),
      body: roomlist.isEmpty
          ? Center(
              child: Text(titlecenter,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)))
          : Column(
              children: [
                Expanded(
                  child: GridView.count(
                    crossAxisCount: rowcount,
                    controller: _scrollController,
                    children: List.generate(scrollcount, (index) {
                      return Card(
                          child: InkWell(
                        onTap: () => {_roomDetails(index)},
                        child: Column(
                          children: [
                            Flexible(
                              flex: 6,
                              child: CachedNetworkImage(
                                width: screenWidth,
                                fit: BoxFit.cover,
                                imageUrl:
                                    "https://slumberjer.com/rentaroom/images/" +
                                        roomlist[index]['roomid'] +
                                        "_1.jpg",
                                placeholder: (context, url) =>
                                    const LinearProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                            Flexible(
                                flex: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    children: [
                                      Text(
                                          truncateString(roomlist[index]
                                                  ['title']
                                              .toString()),
                                          style: TextStyle(
                                              fontSize: resWidth * 0.045,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                          "RM " +
                                              double.parse(
                                                      roomlist[index]['price'])
                                                  .toStringAsFixed(2) +
                                              " /month  ",
                                          style: TextStyle(
                                            fontSize: resWidth * 0.03,
                                          )),
                                      Text(
                                          "Deposit: " +
                                              roomlist[index]['deposit'],
                                          style: TextStyle(
                                            fontSize: resWidth * 0.03,
                                          )),
                                      Text(roomlist[index]['area'],
                                          style: TextStyle(
                                            fontSize: resWidth * 0.03,
                                          )),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ));
                    }),
                  ),
                ),
              ],
            ),
    );
  }

  String truncateString(String str) {
    if (str.length > 13) {
      str = str.substring(0, 13);
      return str + "...";
    } else {
      return str;
    }
  }

  void _loadRooms() {
    http.post(Uri.parse("https://slumberjer.com/rentaroom/php/load_rooms.php"),
        body: {}).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        print(response.body);
        var extractdata = data['data'];
        setState(() {
          roomlist = extractdata["rooms"];
          numroom = roomlist.length;
          if (scrollcount >= roomlist.length) {
            scrollcount = roomlist.length;
          }
        });
      } else {
        setState(() {
          titlecenter = "No Data";
        });
      }
    });
  }

  _roomDetails(int index) {
    Room room = Room(
        roomid: roomlist[index]['roomid'],
        contact: roomlist[index]['contact'],
        title: roomlist[index]['title'],
        desc: roomlist[index]['description'],
        price: roomlist[index]['price'],
        deposit: roomlist[index]['deposit'],
        state: roomlist[index]['state'],
        area: roomlist[index]['area'],
        date: roomlist[index]['date_created'],
        latitude: roomlist[index]['latitude'],
        longitude: roomlist[index]['longitude']);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => DetailPage(
                  room: room,
                )));
  }

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        if (roomlist.length > scrollcount) {
          scrollcount = scrollcount + 10;
          if (scrollcount >= roomlist.length) {
            scrollcount = roomlist.length;
          }
        }
      });
    }
  }
}
