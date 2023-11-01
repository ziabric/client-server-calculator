import 'dart:convert';
import 'dart:io';
import 'package:sqlite3/sqlite3.dart';

void main() async {
  var server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);

  print('Server started on port: ${server.port}');

  await for (var request in server) {
    handleRequest(request);
  }
}

void handleRequest(HttpRequest request) {
  switch (request.method) {
    case 'POST':
      HandlerPOST(request);
      break;
    case 'GET':
      HandlerGET(request);
      break;
    default:
  }
}

void HandlerPOST(HttpRequest request) async {
  final db = sqlite3.open("database");
  Map<dynamic, dynamic> body =
      jsonDecode(await utf8.decoder.bind(request).join());

  String login = body["login"];
  List<dynamic> data1 = body["data"];
  for (var item in data1) {
    String query =
        "INSERT INTO users(login_, data_) VALUES('$login', '$item');";
    db.execute(query);
    print(query);
  }
  request.response
    ..statusCode = HttpStatus.ok
    ..headers.contentType = ContentType.text
    ..write('Ok')
    ..close();
}

void HandlerGET(HttpRequest request) async {
  final db = sqlite3.open("database");

  var recordSet = db.select("SELECT * FROM users");

  String body = '{"login":"example", "data":[';

  for (var item in recordSet) {
    body += '"${item["data_"]}",';
  }
  body = body.substring(0, body.length - 1);
  body += "]}";

  request.response
    ..statusCode = HttpStatus.ok
    ..headers.contentType = ContentType.text
    ..write(body)
    ..close();
}
