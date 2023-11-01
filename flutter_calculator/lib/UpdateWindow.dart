import 'package:flutter/material.dart';
import 'Settings.dart';
import 'package:http/http.dart' as http;

class UpdateWindow extends StatefulWidget {
  const UpdateWindow({super.key});

  @override
  UpdateWindowState createState() => UpdateWindowState();
}

class UpdateWindowState extends State<UpdateWindow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: history.length,
          itemBuilder: (context, index) => Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
              height: 60,
              margin: const EdgeInsets.only(left: 10, top: 10, right: 10),
              padding: const EdgeInsets.only(left: 5, top: 5, right: 5),
              child: Text("${history[index][0]} = ${history[index][1]}",
                  style: const TextStyle(fontSize: 20)))),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton(
              onPressed: () async {
                var url = Uri.parse('http://10.0.2.2:8080');

                String body = '{"login":"example", "data":[';

                for (List<String> item in history) {
                  body += '"${item[0]} = ${item[1]}",';
                }
                body = body.substring(0, body.length - 1);
                body += "]}";

                var response = await http.post(url, body: body);

                if (response.statusCode == 200) {
                  print('Response data: ${response.body}');
                } else {
                  print('Request failed with status: ${response.statusCode}.');
                }
              },
              child: const Text("Send")),
        ],
      ),
    );
  }
}
