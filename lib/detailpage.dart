import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rentaroom/room.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class DetailPage extends StatefulWidget {
  final Room room;
  const DetailPage({Key? key, required this.room}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late double screenHeight, screenWidth, resWidth;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Room Details'),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
              height: screenHeight / 3,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: ImageSlideshow(
                  initialPage: 0,
                  children: [
                    CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: "https://slumberjer.com/rentaroom/images/" +
                          widget.room.roomid.toString() +
                          "_1.jpg",
                      placeholder: (context, url) =>
                          const LinearProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: "https://slumberjer.com/rentaroom/images/" +
                          widget.room.roomid.toString() +
                          "_2.jpg",
                      placeholder: (context, url) =>
                          const LinearProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: "https://slumberjer.com/rentaroom/images/" +
                          widget.room.roomid.toString() +
                          "_3.jpg",
                      placeholder: (context, url) =>
                          const LinearProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ],
                  autoPlayInterval: 3000,
                  isLoop: true,
                ),
              )),
          Text(widget.room.title.toString(),
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 10,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Table(
                  columnWidths: const {
                    0: FractionColumnWidth(0.4),
                    1: FractionColumnWidth(0.6)
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.top,
                  children: [
                    TableRow(children: [
                      const Text('Description',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(widget.room.desc.toString()),
                    ]),
                    TableRow(children: [
                      const Text('Price',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text("RM " +
                          double.parse(widget.room.price.toString())
                              .toStringAsFixed(2) +
                          "/month"),
                    ]),
                    TableRow(children: [
                      const Text('Deposit',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text("RM " + widget.room.deposit.toString()),
                    ]),
                    TableRow(children: [
                      const Text('State',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(widget.room.state.toString()),
                    ]),
                    TableRow(children: [
                      const Text('Locality',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(widget.room.area.toString()),
                    ]),
                    TableRow(children: [
                      const Text('Date Created',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(widget.room.date.toString()),
                    ]),
                    TableRow(children: [
                      const Text('Latitude',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(widget.room.latitude.toString()),
                    ]),
                    TableRow(children: [
                      const Text('Longitude',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(widget.room.longitude.toString()),
                    ]),
                    TableRow(children: [
                      const Text('Contact',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(widget.room.contact.toString()),
                    ]),
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
