import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'dart:collection';
import 'package:pie_chart/pie_chart.dart';

class AnalysisPage extends StatefulWidget {
  String imagePath;
  AnalysisPage({Key? key, required this.imagePath}) : super(key: key);

  @override
  _AnalysisPageState createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  var dataMap;
  var analysisResult;
  var sortedAnalysis;
  bool isAnalyzed = false;
  bool showInfo = false;
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      String? res = await Tflite.loadModel(
          model: "assets/model.tflite",
          labels: "assets/labels.txt",
          numThreads: 1, // defaults to 1
          isAsset:
              true, // defaults to true, set to false to load resources outside assets
          useGpuDelegate:
              false // defaults to false, set to true to use GPU delegate
          );
    });

    Future.delayed(Duration.zero, () async {
      var recognitions = await Tflite.runModelOnImage(
          path: widget.imagePath, // required
          imageMean: 0.0, // defaults to 117.0
          imageStd: 255.0, // defaults to 1.0
          numResults: 2, // defaults to 5
          threshold: 0.2, // defaults to 0.1
          asynch: true // defaults to true
          );
      if (recognitions != null) {
        setState(() {
          isAnalyzed = true;
          startShowInfoTimer();
          analysisResult = recognitions;
          sortedAnalysis = objectSort(analysisResult);
          dataMap = generateDataMap();

          // sortedAnalysis = objectSort(analysisResult);

          // print('analysis result is $recognitions');
        });
      }
    });
  }

  Future<void> startShowInfoTimer() async {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        showInfo = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    Future.delayed(Duration.zero, () async {
      await Tflite.close();
    });
  }

  Map<String, dynamic> generateDataMap() {
    Map resultMap = {};
    List typesList = ['Type1', 'Type2', 'Type3'];
    for (Map result in sortedAnalysis) {
      resultMap[result['type']] = result['confidence'];
    }
    for (var type in typesList) {
      if (!resultMap.keys.contains(type)) {
        double sum = 0.0;
        for (var value in resultMap.values) {
          sum += value;
        }
        resultMap[type] = 1 - sum;
      }
    }
    // final validMap =
    //     json.decode(json.encode(resultMap)) as Map<String, dynamic>;
    final validMap = Map<String, dynamic>.from(resultMap);
    return validMap;
  }

  List? objectSort(List analysisList) {
    List resultList = [];
    List<dynamic> confidences = analysisList.map((result) {
      // print(result['confidence'].runtimeType);
      return result['confidence'];
    }).toList();
    List<dynamic> sortedConfidences = bubbleSort(confidences);
    for (dynamic confidence in sortedConfidences) {
      for (Map analysis in analysisResult) {
        if (analysis['confidence'] == confidence) {
          resultList.add({
            'type': analysis['label'],
            'index': analysis['index'],
            'confidence': analysis['confidence']
          });
        }
      }
    }
    print(resultList);
    return resultList;
  }

  bubbleSort(List<dynamic> array) {
    int lengthOfArray = array.length;
    for (int i = 0; i < lengthOfArray - 1; i++) {
      for (int j = 0; j < lengthOfArray - i - 1; j++) {
        if (array[j] > array[j + 1]) {
          // Swapping using temporary variable
          dynamic temp = array[j];
          array[j] = array[j + 1];
          array[j + 1] = temp;
        }
      }
    }
    List<dynamic> reversedList = List.from(array.reversed);
    return (reversedList);
  }

  // List<Widget> _gradingWidget() {
  //   List<double> confidences =
  //       analysisResult.map((result) => result['confidence']).toList();
  //   return [Text(confidences.toString())];
  //   // final sorted = SplayTreeMap.from(
  //   // analysisResult, (key1, key2) => analysisResult[key1].compareTo(analysisResult[key2]));
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height * 3 / 2,
          child: Column(
            children: [
              Column(children: [
                Stack(alignment: Alignment.center, children: [
                  Image.file(
                    File(widget.imagePath),
                  ),
                  AnimatedSwitcher(
                      duration: const Duration(seconds: 1),
                      child: isAnalyzed
                          ? AnimatedSwitcher(
                              duration: const Duration(seconds: 1),
                              child: isAnalyzed
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        PieChart(
                                          dataMap: {
                                            'Type1': dataMap['Type1'],
                                            'Type2': dataMap['Type2'],
                                            'Type3': dataMap['Type3']
                                          },
                                          animationDuration:
                                              const Duration(milliseconds: 800),
                                          chartLegendSpacing: 32,
                                          chartRadius: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3.2,
                                          initialAngleInDegree: 0,
                                          chartType: ChartType.ring,
                                          ringStrokeWidth: 32,
                                          centerText: "Type prediction",
                                          legendOptions: const LegendOptions(
                                            showLegendsInRow: false,
                                            legendPosition:
                                                LegendPosition.right,
                                            showLegends: true,
                                            legendTextStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          chartValuesOptions:
                                              const ChartValuesOptions(
                                            showChartValueBackground: true,
                                            showChartValues: true,
                                            showChartValuesInPercentage: false,
                                            showChartValuesOutside: false,
                                            decimalPlaces: 1,
                                          ),
                                        ),
                                        // Text(analysisResult!.toString()),
                                        // Text(sortedAnalysis!.toString()),
                                        ...sortedAnalysis
                                            .map((metrics) => Container(
                                                  margin:
                                                      EdgeInsets.only(top: 20),
                                                  height: sortedAnalysis
                                                              .indexOf(
                                                                  metrics) ==
                                                          0
                                                      ? MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          8
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          10,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: [
                                                      Expanded(
                                                        child: Opacity(
                                                          opacity: 0.7,
                                                          child: Container(
                                                            child: Center(
                                                              child: Text(
                                                                  '${metrics['type']}'),
                                                            ),
                                                            decoration: BoxDecoration(
                                                                color: sortedAnalysis.indexOf(
                                                                            metrics) ==
                                                                        0
                                                                    ? Colors.red
                                                                    : Colors.blue[
                                                                        400],
                                                                shape: BoxShape
                                                                    .circle),
                                                          ),
                                                        ),
                                                      ),
                                                      FractionallySizedBox(
                                                        alignment:
                                                            Alignment.center,
                                                        heightFactor: 1 / 2,
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                          ),
                                                          child: Text(
                                                              'confidence-> ${metrics['confidence']}'),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ))
                                            .toList(),

                                        // TextButton(
                                        //   onPressed: () {
                                        //     print(generateDataMap().toString());
                                        //     // List<dynamic> confidences =
                                        //     //     analysisResult.map((result) {
                                        //     //   // print(result['confidence'].runtimeType);
                                        //     //   return result['confidence'];
                                        //     // }).toList();
                                        //     // print('all confidences are -> $confidences');
                                        //     // List<dynamic> sortedConfidences =
                                        //     //     bubbleSort(confidences);
                                        //     // print(
                                        //     //     'sorted confidences are ${sortedConfidences.toString()}');

                                        //     // print(
                                        //     //     'sorted confidences are -> ${sortedConfidences.toString()}');

                                        //     // print(confidences.toString());

                                        //     // print('result is -> ${analysisResult![0]}');
                                        //   },
                                        //   // child: const Text('press me to examine data'),
                                        // ),
                                      ],
                                    )
                                  : const Center(
                                      child: CircularProgressIndicator()))
                          : const Center(child: CircularProgressIndicator()))
                ]),
                AnimatedSwitcher(
                  duration: const Duration(seconds: 3),
                  child: showInfo
                      ? Image.asset('assets/images/cervix_types.png')
                      : Container(),
                )
              ]),
              Expanded(
                  child: Container(
                child: AnimatedSwitcher(
                  duration: const Duration(seconds: 1),
                  child: isAnalyzed
                      ? Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Spacer(
                              flex: 1,
                            ),
                            Expanded(
                              flex: 2,
                              child: FractionallySizedBox(
                                widthFactor: 1 / 2,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    child: const Icon(
                                      Icons.arrow_back,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: Colors.white70,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(flex: 1),
                            // IconButton(
                            //     iconSize: 40,
                            //     focusColor: Colors.red,
                            //     color: Colors.white60,
                            //     onPressed: () {
                            //       Navigator.pop(context);
                            //     },
                            //     icon: const Icon(Icons.arrow_back)),
                          ],
                        )
                      : Container(),
                ),
                color: Colors.black,
              ))
            ],
          ),
        ),
      ),
    );
  }
}
