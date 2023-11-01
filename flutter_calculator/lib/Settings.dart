import 'package:flutter/material.dart';

enum SignType { None, Plus, Minus, Multiplication, Division, Percent }

const buttonTextStyle = TextStyle(fontSize: 30);

List<List<String>> history = [];
List<String> showAllData = [];

/*

  0 -- eng
  1 -- ru

*/
int langState = 1;

List<DropdownMenuItem<String>> langList = [
  DropdownMenuItem(child: Text("Eng")),
  DropdownMenuItem(child: Text("Rus"))
];

List<Map<String, String>> keywordList = [
  {
    "error": "Error",
    "errorText": "You can't divide by zero",
    "appBar": "Calculator",
    "clear": "Clear",
    "showAll": "Show All",
    "send": "Send",
    "change": "Change lang"
  },
  {
    "error": "Ошибка",
    "errorText": "Делить на ноль нельзя",
    "appBar": "Калькулятор",
    "clear": "Очистка",
    "showAll": "Показать все",
    "send": "Отправить",
    "change": "Сменить язык"
  }
];
