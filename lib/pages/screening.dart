import 'package:flutter/material.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';

class Screening extends StatefulWidget {
  const Screening({Key? key}) : super(key: key);

  @override
  _ScreeningState createState() => _ScreeningState();
}

class _ScreeningState extends State<Screening> {
  final List<String> titles = [
    "take a photo",
    "load from \n gallery",
  ];

  final List<Widget> images = [
    ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Image.asset(
        "assets/images/take_photo.jpg",
        fit: BoxFit.cover,
      ),
    ),
    ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Image.asset(
        "assets/images/load_from_gallery.jpg",
        fit: BoxFit.cover,
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
          // backgroundBlendMode: BlendMode.colorDodge,
          gradient: LinearGradient(colors: [
        Colors.lightBlueAccent,
        Colors.blueAccent,
        Colors.purple,
        Colors.deepPurpleAccent,
        Colors.deepPurple,
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Column(
        children: [
          Container(
            color: Colors.blue,
            height: MediaQuery.of(context).size.height / 10,
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white38,
                      )),
                  const Text('Cervical type screening',
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
          Expanded(
            child: VerticalCardPager(
                titles: titles, // required
                images: images, // required
                textStyle: const TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.w400), // optional
                onPageChanged: (page) {
                  // optional
                },
                onSelectedItem: (index) {
                  print('selected item is ->$index');
                },
                initialPage: 0, // optional
                align: ALIGN.CENTER // optional
                ),
          ),
        ],
      ),
    ));
  }
}
