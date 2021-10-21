import 'package:flutter/material.dart';

class Checker extends StatefulWidget {
  const Checker({Key? key}) : super(key: key);

  @override
  _CheckerState createState() => _CheckerState();
}

class _CheckerState extends State<Checker> {
  List<Widget> animatedChildren = [];
  var _genderValue;
  var _selectedValue;
  @override
  Widget build(BuildContext context) {
    List<Widget> allWidgets = [
      FractionallySizedBox(
        widthFactor: 0.9,
        child: DropdownButton(
          hint: const Text('gender'),
          isExpanded: true,
          onChanged: (val) {
            setState(() {
              _genderValue = val;
            });
          },
          value: _genderValue,
          items: const [
            DropdownMenuItem(
              child: Text('Male'),
              value: 'Male',
            ),
            DropdownMenuItem(
              child: Text('Female'),
              value: 'Female',
            )
          ],
        ),
      ),
      FractionallySizedBox(
        widthFactor: 0.9,
        child: DropdownButton(
          hint: const Text('gender'),
          isExpanded: true,
          onChanged: (val) {
            setState(() {
              _selectedValue = val;
            });
          },
          value: _selectedValue,
          items: const [
            DropdownMenuItem(
              child: Text('Male'),
              value: 1,
            ),
            DropdownMenuItem(
              child: Text('Female'),
              value: 2,
            )
          ],
        ),
      ),
    ];
    Size size = MediaQuery.of(context).size;
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
            child: Column(children: [
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
                        const Text('Check control time',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  )),
              SizedBox(
                height: size.height / 20,
              ),
              TextButton(
                  onPressed: () {
                    setState(() {
                      animatedChildren.removeLast();
                    });
                  },
                  child: Text('press me to change animated switcher afdljk')),
              AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: Column(
                  children: animatedChildren,
                ),
              ),

              // FractionallySizedBox(
              //   widthFactor: 0.9,
              //   child: DropdownButtonFormField(
              //     dropdownColor: Colors.red.withAlpha(50),
              //     decoration: InputDecoration(),
              //     value: _selectedValue,
              //     hint: const Text(
              //       'choose one',
              //     ),
              //     isExpanded: true,
              //     onChanged: (value) {
              //       setState(() {
              //         // FocusScope.of(context).requestFocus(FocusNode());
              //         _selectedValue = value;
              //         FocusScope.of(context).unfocus();
              //       });
              //     },
              //     items: const [
              //       DropdownMenuItem(
              //         child: Text('naber'),
              //         value: 1,
              //       ),
              //       DropdownMenuItem(child: Text('iyilik '), value: 2),
              //       DropdownMenuItem(child: Text('kraker'), value: 3),
              //     ],
              //   ),
              // )
            ])));
  }
}
