import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'pages/screening.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum Pages { scanning, checker }

class _MyHomePageState extends State<MyHomePage> {
  Pages? currentPage;
  Route _createScreeningRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const Screening(),
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

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        currentPage = Pages.scanning;
      });
    });
    precacheImage(AssetImage("assets/images/cervix_screening.jpg"), context);
    precacheImage(AssetImage("assets/images/scanning_tests.jpg"), context);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Column(
        // Column is also a layout widget. It takes a list of children and
        // arranges them vertically. By default, it sizes itself to fit its
        // children horizontally, and tries to be as tall as its parent.
        //
        // Invoke "debug painting" (press "p" in the console, choose the
        // "Toggle Debug Paint" action from the Flutter Inspector in Android
        // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
        // to see the wireframe for each widget.
        //
        // Column has various properties to control how it sizes itself and
        // how it positions its children. Here we use mainAxisAlignment to
        // center the children vertically; the main axis here is the vertical
        // axis because Columns are vertical (the cross axis would be
        // horizontal).
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Stack(alignment: Alignment.center, children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        print('scanning section is clicked');
                        setState(() {
                          currentPage = Pages.scanning;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          // boxShadow: currentPage == Pages.checker
                          //     ? [
                          //         const BoxShadow(
                          //             color: Colors.orange,
                          //             blurRadius: 5,
                          //             offset: Offset(0, -30))
                          //       ]
                          //     : []
                        ),
                        child: Stack(fit: StackFit.expand, children: [
                          ColorFiltered(
                            colorFilter: const ColorFilter.mode(
                                Colors.red, BlendMode.colorBurn),
                            child: Opacity(
                              opacity: 0.9,
                              child: Image.asset(
                                'assets/images/cervix_screening.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: currentPage == Pages.scanning
                                ? Align(
                                    alignment: Alignment.bottomLeft,
                                    child: FractionallySizedBox(
                                      widthFactor: 0.45,
                                      heightFactor: 0.1,
                                      child: Opacity(
                                        opacity: 0.7,
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'Evaluate cervix type',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                          decoration: const BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.blue,
                                                  blurRadius: 5),
                                              BoxShadow(
                                                  color: Colors.white,
                                                  blurRadius: 5)
                                            ],
                                            color: Colors.blue,
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(100)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ),
                          AnimatedPositioned(
                            left: MediaQuery.of(context).size.width / 2 - 30,
                            curve: Curves.easeInOutQuart,
                            top: currentPage == Pages.scanning
                                ? MediaQuery.of(context).size.height / 4
                                : 0,
                            duration: const Duration(seconds: 1),
                            child: AnimatedOpacity(
                              opacity: currentPage == Pages.scanning ? 1 : 0,
                              duration: const Duration(seconds: 1),
                              child: IconButton(
                                color: Colors.blue,
                                onPressed: () {
                                  print('screening button is pressed');
                                  Navigator.of(context)
                                      .push(_createScreeningRoute());
                                },
                                icon: const Icon(
                                  Icons.play_circle_fill,
                                  size: 60,
                                ),
                              ),
                            ),
                          )
                        ]),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        print('checker section is clicked');
                        setState(() {
                          currentPage = Pages.checker;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            boxShadow: currentPage == Pages.scanning
                                ? [
                                    const BoxShadow(
                                        color: Colors.blue, blurRadius: 25)
                                  ]
                                : []

                            // [
                            //     const BoxShadow(
                            //       color: Colors.orange,
                            //       blurRadius: 15,
                            //       spreadRadius: -5,
                            //     )
                            //   ]

                            ),
                        child: Stack(fit: StackFit.expand, children: [
                          ColorFiltered(
                            colorFilter: const ColorFilter.mode(
                                Colors.blue, BlendMode.overlay),
                            child: Opacity(
                              opacity: 0.9,
                              child: Image.asset(
                                'assets/images/scanning_tests.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: currentPage == Pages.checker
                                ? Align(
                                    alignment: Alignment.topRight,
                                    child: FractionallySizedBox(
                                      widthFactor: 0.45,
                                      heightFactor: 0.1,
                                      child: Opacity(
                                        opacity: 0.7,
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: const Text(
                                              'Check Control time',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                          decoration: const BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.redAccent,
                                                  blurRadius: 5)
                                            ],
                                            color: Colors.red,
                                            borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(100)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ),
                          AnimatedPositioned(
                            left: MediaQuery.of(context).size.width / 2 - 30,
                            curve: Curves.easeInOutQuart,
                            bottom: currentPage == Pages.checker
                                ? MediaQuery.of(context).size.height / 4
                                : 0,
                            duration: const Duration(seconds: 1),
                            child: AnimatedOpacity(
                              opacity: currentPage == Pages.checker ? 1 : 0,
                              duration: const Duration(seconds: 1),
                              child: IconButton(
                                color: Colors.red,
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.play_circle_fill,
                                  size: 60,
                                ),
                              ),
                            ),
                          )
                        ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              width: MediaQuery.of(context).size.width,
              height: 0,
              duration: const Duration(seconds: 1),
              decoration: BoxDecoration(
                  color: Colors.red,
                  boxShadow: currentPage == Pages.checker
                      ? [
                          const BoxShadow(
                            color: Colors.orange,
                            blurRadius: 10,
                            spreadRadius: 4,
                            offset: Offset(0, 5),
                          )
                        ]
                      : []),
            ),
          ])
        ],
      ),
    );
  }
}
