import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_calculator/Settings.dart';
import 'package:flutter_calculator/ShowAllWindow.dart';
import 'package:flutter_calculator/UpdateWindow.dart';
import 'package:http/http.dart' as http;

class MainWindow extends StatefulWidget {
  const MainWindow({super.key});

  @override
  MainWindowState createState() => MainWindowState();
}

class MainWindowState extends State<MainWindow> {
  SignType signType = SignType.None;
  String firstNumberValue = "0";
  String secondNumberValue = "0";
  String signString = "";
  bool commaFlag = false;

  void getAnswer() {
    double leftValue = double.parse(firstNumberValue);
    double rightValue = double.parse(secondNumberValue);

    double answer = 0;

    switch (signType) {
      case SignType.Plus:
        {
          answer = leftValue + rightValue;
          break;
        }
      case SignType.Minus:
        {
          answer = leftValue - rightValue;
          break;
        }
      case SignType.Multiplication:
        {
          answer = leftValue * rightValue;
          break;
        }
      case SignType.Division:
        {
          if (rightValue != 0) {
            answer = leftValue / rightValue;
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(keywordList[langState]["error"]!),
                content: Text(keywordList[langState]["errorText"]!),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
          break;
        }
      case SignType.Percent:
        {
          answer = leftValue % rightValue;
          break;
        }
      default:
        {
          answer = 0;
          break;
        }
    }

    history.add([
      """$firstNumberValue  $signString  $secondNumberValue""",
      """${answer.toInt() != answer ? answer : answer.toInt()}"""
    ]);

    eraseAll();

    if (answer.toInt() != answer) {
      commaFlag = true;
      firstNumberValue = answer.toString();
    } else {
      firstNumberValue = answer.toInt().toString();
    }
  }

  void addSign(SignType type) {
    signType = type;
    commaFlag = false;
    switch (type) {
      case SignType.Plus:
        {
          signString = "+";
          break;
        }
      case SignType.Minus:
        {
          signString = "-";
          break;
        }
      case SignType.Multiplication:
        {
          signString = "x";
          break;
        }
      case SignType.Division:
        {
          signString = "/";
          break;
        }
      case SignType.Percent:
        {
          signString = "%";
          break;
        }
      default:
        {
          signString = "";
          break;
        }
    }
    setState(() {});
  }

  void addSymbol(String value) {
    if (signType == SignType.None && firstNumberValue.length > 15)
      return;
    else if (secondNumberValue.length > 15) return;

    if (signType == SignType.None) {
      if (value == '.' && commaFlag) return;
      if (value != "." && firstNumberValue == "0") {
        firstNumberValue =
            firstNumberValue.substring(0, firstNumberValue.length - 1);
      }
      firstNumberValue += value;
    } else {
      if (value == '.' && commaFlag) return;
      if (value != "." && secondNumberValue == "0") {
        secondNumberValue =
            secondNumberValue.substring(0, secondNumberValue.length - 1);
      }
      secondNumberValue += value;
    }

    if (value == '.') commaFlag = true;

    setState(() {});
  }

  void eraseAll() {
    signType = SignType.None;
    firstNumberValue = "0";
    secondNumberValue = "0";
    signString = "";
    commaFlag = false;

    setState(() {});
  }

  void eraseSymbol() {
    if (signType == SignType.None) {
      if (firstNumberValue[firstNumberValue.length - 1] == '.')
        commaFlag = false;
      firstNumberValue =
          firstNumberValue.substring(0, firstNumberValue.length - 1);
      if (firstNumberValue.isEmpty) firstNumberValue += "0";
    } else {
      if (secondNumberValue[secondNumberValue.length - 1] == '.')
        commaFlag = false;
      secondNumberValue =
          secondNumberValue.substring(0, secondNumberValue.length - 1);
      if (secondNumberValue.isEmpty) secondNumberValue += "0";
    }

    setState(() {});
  }

  void addMinus() {
    if (signType == SignType.None) {
      if (double.parse(firstNumberValue) > 0) {
        var tmp = firstNumberValue.split('');
        tmp.insert(0, '-');
        firstNumberValue = tmp.join();
      } else if (double.parse(firstNumberValue) < 0) {
        firstNumberValue = firstNumberValue.substring(1);
      }
    } else {
      if (double.parse(secondNumberValue) > 0) {
        var tmp = secondNumberValue.split('');
        tmp.insert(0, '-');
        secondNumberValue = tmp.toString();
      } else if (double.parse(secondNumberValue) < 0) {
        secondNumberValue = secondNumberValue.substring(1);
      }
    }
    setState(() {});
  }

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text(''),
        action:
            SnackBarAction(label: '', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String currentValue =
        signType == SignType.None ? firstNumberValue : secondNumberValue;

    return MaterialApp(
      home: Scaffold(
        drawer: Drawer(
          child: ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) => Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.blue)),
                  height: 60,
                  margin: const EdgeInsets.only(left: 10, top: 10, right: 10),
                  padding: const EdgeInsets.only(left: 5, top: 5, right: 5),
                  child: Text("${history[index][0]} = ${history[index][1]}",
                      style: const TextStyle(fontSize: 20)))),
        ),
        appBar: AppBar(
          title: Text(keywordList[langState]["appBar"]!),
        ),
        body: Column(
          children: [
            Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(right: 20),
              child: Text(
                signString,
                style: const TextStyle(color: Colors.black, fontSize: 25),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 20),
              alignment: Alignment.centerRight,
              child: Text(
                currentValue,
                style: const TextStyle(color: Colors.black, fontSize: 60),
              ),
            ),
            SizedBox(
              height: 30,
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      child: Text(keywordList[langState]["clear"]!),
                      onPressed: () {
                        setState(() {
                          history.clear();
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      child: Text(keywordList[langState]["send"]!),
                      onPressed: () async {
                        if (history.isNotEmpty) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UpdateWindow()));
                        } else {
                          _showToast(context);
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      child: Text(keywordList[langState]["showAll"]!),
                      onPressed: () async {
                        var url = Uri.parse('http://10.0.2.2:8080');

                        var response = await http.get(url);

                        if (response.statusCode == 200) {
                          Map<dynamic, dynamic> body =
                              jsonDecode(response.body);
                          setState(() {
                            showAllData.clear();
                            String login = body["login"];
                            List<dynamic> data1 = body["data"];
                            for (var item in data1) {
                              showAllData.add(item);
                              print(item);
                            }
                          });

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShowAllWindow()));
                        } else {
                          print(
                              'Request failed with status: ${response.statusCode}.');
                        }
                      },
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          if (langState == 0) {
                            langState = 1;
                          } else {
                            langState = 0;
                          }
                        });
                      },
                      child: Text(keywordList[langState]["change"]!))
                ],
              ),
            ),
            Expanded(
                child: Column(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                          child: TextButton(
                              onPressed: () {
                                eraseAll();
                              },
                              child: const Text(
                                "AC",
                                style: buttonTextStyle,
                              ))),
                      Expanded(
                          child: TextButton(
                              onPressed: () {
                                eraseSymbol();
                              },
                              child: const Text("C", style: buttonTextStyle))),
                      Expanded(
                          child: TextButton(
                              onPressed: () {
                                addSign(SignType.Percent);
                              },
                              child: const Text("%", style: buttonTextStyle))),
                      Expanded(
                          child: TextButton(
                              onPressed: () {
                                addSign(SignType.Division);
                              },
                              child: const Text("/", style: buttonTextStyle))),
                    ],
                  ),
                ),
                Expanded(
                    child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                        child: TextButton(
                            onPressed: () {
                              addSymbol("7");
                            },
                            child: const Text("7", style: buttonTextStyle))),
                    Expanded(
                        child: TextButton(
                            onPressed: () {
                              addSymbol("8");
                            },
                            child: const Text("8", style: buttonTextStyle))),
                    Expanded(
                        child: TextButton(
                            onPressed: () {
                              addSymbol("9");
                            },
                            child: const Text("9", style: buttonTextStyle))),
                    Expanded(
                        child: TextButton(
                            onPressed: () {
                              addSign(SignType.Multiplication);
                            },
                            child: const Text("x", style: buttonTextStyle))),
                  ],
                )),
                Expanded(
                    child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                        child: TextButton(
                            onPressed: () {
                              addSymbol("4");
                            },
                            child: const Text("4", style: buttonTextStyle))),
                    Expanded(
                        child: TextButton(
                            onPressed: () {
                              addSymbol("5");
                            },
                            child: const Text("5", style: buttonTextStyle))),
                    Expanded(
                        child: TextButton(
                            onPressed: () {
                              addSymbol("6");
                            },
                            child: const Text("6", style: buttonTextStyle))),
                    Expanded(
                        child: TextButton(
                            onLongPress: () {
                              addMinus();
                            },
                            onPressed: () {
                              addSign(SignType.Minus);
                            },
                            child: const Text("-", style: buttonTextStyle))),
                  ],
                )),
                Expanded(
                    child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                        child: TextButton(
                            onPressed: () {
                              addSymbol("1");
                            },
                            child: const Text("1", style: buttonTextStyle))),
                    Expanded(
                        child: TextButton(
                            onPressed: () {
                              addSymbol("2");
                            },
                            child: const Text("2", style: buttonTextStyle))),
                    Expanded(
                        child: TextButton(
                            onPressed: () {
                              addSymbol("3");
                            },
                            child: const Text("3", style: buttonTextStyle))),
                    Expanded(
                        child: TextButton(
                            onPressed: () {
                              addSign(SignType.Plus);
                            },
                            child: const Text("+", style: buttonTextStyle))),
                  ],
                )),
                Expanded(
                    child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                        flex: 2,
                        child: TextButton(
                            onPressed: () {
                              addSymbol("0");
                            },
                            child: const Text("0", style: buttonTextStyle))),
                    Expanded(
                        child: TextButton(
                            onPressed: () {
                              addSymbol(".");
                            },
                            child: const Text(".", style: buttonTextStyle))),
                    Expanded(
                        child: TextButton(
                            onPressed: () {
                              getAnswer();
                            },
                            child: const Text("=", style: buttonTextStyle))),
                  ],
                )),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
