import 'package:flutter/material.dart';

class MyCalculatorPage extends StatefulWidget {
  const MyCalculatorPage({Key key}) : super(key: key);

  @override
  _MyCalculatorPageState createState() => _MyCalculatorPageState();
}

class _MyCalculatorPageState extends State<MyCalculatorPage> {
  String answer;
  String answerTemp;
  String inputFull;
  String operator;
  bool calculateMode;

  @override
  void initState() {
    answer = "0";
    operator = "";
    answerTemp = "";
    inputFull = "";
    calculateMode = false;
    super.initState();
  }

  void addNumberToAnswer(int number) {
    setState(() {
      if (answer == "ไม่นิยาม") {
        answer = "0";
      }
      if (number == 0 && answer == "0") {
        // Not do anything.
      } else if (number != 0 && answer == "0") {
        answer = number.toString();
      } else if ((number != 0 && answer == "-0")) {
        answer = "-" + number.toString();
      } else {
        answer += number.toString();
      }
    });
  }

  void addDotToAnswer() {
    setState(() {
      if (answer == "ไม่นิยาม") {
        answer = "0";
      }
      if (!answer.contains(".")) {
        answer = answer + ".";
      }
    });
  }

  void toggleNegative() {
    setState(() {
      if (answer == "ไม่นิยาม") {
        answer = "0";
      }
      if (answer.contains("-")) {
        answer = answer.replaceAll("-", "");
      } else {
        answer = "-" + answer;
      }
    });
  }

  void addOperatorToAnswer(String op) {
    setState(() {
      if (answer != "0" && answer != "ไม่นิยาม" && !calculateMode) {
        calculateMode = true;
        answerTemp = answer;
        inputFull += operator + " " + answerTemp;
        operator = op;
        answer = "0";
      } else if (calculateMode) {
        if (answer.isNotEmpty) {
          calculate();
          answerTemp = answer;
          inputFull = "";
          operator = "";
        } else {
          operator = op;
        }
      }
    });
  }

  void calculate() {
    setState(() {
      if (calculateMode) {
        bool decimalMode = false;
        double value = 0;
        if (answer.contains(".") || answerTemp.contains(".")) {
          decimalMode = true;
        }

        if (operator == "+") {
          value = (double.parse(answerTemp) + double.parse(answer));
        } else if (operator == "-") {
          value = (double.parse(answerTemp) - double.parse(answer));
        } else if (operator == "×") {
          value = (double.parse(answerTemp) * double.parse(answer));
        } else if (operator == "÷") {
          value = (double.parse(answerTemp) / double.parse(answer));
        }

        print(value);

        if (!decimalMode) {
          answer = value.toInt().toString();
        } else {
          answer = value.toString();
        }
        if (answer == "NaN") {
          answer = "ไม่นิยาม";
        }

        calculateMode = false;
        operator = "";
        answerTemp = "";
        inputFull = "";
      }
    });
  }

  void removeAnswerLast() {
    if (answer == "0") {
    } else {
      setState(() {
        if (answer == "ไม่นิยาม") {
          answer = "0";
        }
        if (answer.length > 1) {
          answer = answer.substring(0, answer.length - 1);
          if (answer.length == 1 && (answer == "." || answer == "-")) {
            answer = "0";
          }
        } else {
          answer = "0";
        }
      });
    }
  }

  void clearAnswer() {
    setState(() {
      answer = "0";
    });
  }

  void clearAll() {
    setState(() {
      answer = "0";
      inputFull = "";
      calculateMode = false;
      operator = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            answerWidget(),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: <Widget>[
                    numberButton("CE",
                        colorBt: Colors.indigo.shade100, onTap: () => clearAnswer()),
                    numberButton("C",
                        colorBt: Colors.indigo.shade100, onTap: () => clearAll()),
                    numberButton("⌫",
                        colorBt: Colors.indigo.shade100,
                        onTap: () => removeAnswerLast()),
                    numberButton("÷",
                        colorBt: Colors.indigo.shade100,
                        onTap: () => addOperatorToAnswer("÷")),
                  ],
                ),
                Row(
                  children: [
                    numberButton("7", onTap: () => addNumberToAnswer(7)),
                    numberButton("8", onTap: () => addNumberToAnswer(8)),
                    numberButton("9", onTap: () => addNumberToAnswer(9)),
                    numberButton("×",
                        colorBt: Colors.indigo.shade100,
                        onTap: () => addOperatorToAnswer("×")),
                  ],
                ),
                Row(
                  children: [
                    numberButton("4", onTap: () => addNumberToAnswer(4)),
                    numberButton("5", onTap: () => addNumberToAnswer(5)),
                    numberButton("6", onTap: () => addNumberToAnswer(6)),
                    numberButton("-",
                        colorBt: Colors.indigo.shade100,
                        onTap: () => addOperatorToAnswer("-")),
                  ],
                ),
                Row(
                  children: [
                    numberButton("1", onTap: () => addNumberToAnswer(1)),
                    numberButton("2", onTap: () => addNumberToAnswer(2)),
                    numberButton("3", onTap: () => addNumberToAnswer(3)),
                    numberButton("+",
                        colorBt: Colors.indigo.shade100,
                        onTap: () => addOperatorToAnswer("+")),
                  ],
                ),
                Row(
                  children: <Widget>[
                    numberButton("±",
                        colorBt: Colors.indigo.shade100,
                        onTap: () => toggleNegative()),
                    numberButton("0", onTap: () => addNumberToAnswer(0)),
                    numberButton(".",
                        colorBt: Colors.indigo.shade100,
                        onTap: () => addDotToAnswer()),
                    numberButton("=",
                        colorBt: Colors.indigo.shade100, onTap: () => calculate()),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget answerWidget() {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(16),
      constraints: BoxConstraints.expand(height: size.height * 0.25),
      color: Colors.indigo.shade200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "$inputFull $operator",
            style: Theme.of(context)
                .textTheme
                .subtitle1
                .copyWith(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Text(
            answer,
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .headline3
                .copyWith(fontWeight: FontWeight.bold, color: Colors.black),
          )
        ],
      ),
    );
  }

  Widget numberButton(String str,
      {Color colorStr = Colors.black,
      Color colorBt = Colors.white,
      @required Function() onTap}) {
    Size size = MediaQuery.of(context).size;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.all(2),
          color: colorBt,
          height: size.height * 0.6 / 5,
          child: Center(
            child: Text(
              str,
              style: Theme.of(context).textTheme.headline5.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorStr,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
