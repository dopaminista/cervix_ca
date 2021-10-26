import 'package:flutter/material.dart';

class Checker extends StatefulWidget {
  const Checker({Key? key}) : super(key: key);

  @override
  _CheckerState createState() => _CheckerState();
}

class _CheckerState extends State<Checker> {
  @override
  // void initState(){
  //   Future.delayed(Duration.zero, ()async{
  // /// Will used to access the Animated list
  // /// for (int item in _fetchedItems) {
  //   // 1) Wait for one second
  //   await Future.delayed(Duration(milliseconds: 1000));
  //   // 2) Adding data to actual variable that holds the item.
  //   _items.add(item);
  //   // 3) Telling animated list to start animation
  //   listKey.currentState.insertItem(_items.length - 1);
  // }
  //   });
  // }
  // /// Will used to access the Animated list
  // final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  // /// This holds the items
  // List<int> _items = [];

  /// This holds the item count
  int counter = 0;

  // Widget slideIt(BuildContext context, int index, animation) {
  //   int item = _items[index];

  //   return SlideTransition(
  //     position: Tween<Offset>(
  //       begin: const Offset(-1, 0),
  //       end: Offset(0, 0),
  //     ).animate(animation),
  //     child: SizedBox(
  //       // Actual widget to display
  //       height: 128.0,
  //       child: Card(
  //         color: Colors.primaries[item % Colors.primaries.length],
  //         child: Center(
  //           child: Text(
  //             'Item $item',
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(15),
                  child: Text('Under development'),
                ),
              ),
              // Expanded(
              //   child: AnimatedList(
              //     key: listKey,
              //     initialItemCount: _items.length,
              //     itemBuilder: (context, index, animation) {
              //       return slideIt(context, index, animation); // Refer step 3
              //     },
              //   ),
              // ),
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
