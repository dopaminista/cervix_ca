import 'package:cervix_ca/state_management/widget_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';
import 'camera_page.dart';
import 'package:image_picker/image_picker.dart';
import 'analysis_page.dart';

class Screening extends StatefulWidget {
  const Screening({Key? key}) : super(key: key);

  @override
  _ScreeningState createState() => _ScreeningState();
}

class _ScreeningState extends State<Screening> {
  Route _createScreeningRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          TakePictureScreen(
        camera: Provider.of<WidgetController>(context).camera!,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

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
                onSelectedItem: (index) async {
                  print('selected item is ->$index');
                  if (index == 0) {
                    Navigator.of(context).push(_createScreeningRoute());
                  } else if (index == 1) {
                    final ImagePicker _picker = ImagePicker();
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              AnalysisPage(imagePath: image.path)));
                    }
                  }
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
