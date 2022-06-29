import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController url = TextEditingController();
  String shortUrl = '';

  Future send(String url) async {
    var response = await http.post(
      Uri.parse('https://api-ssl.bitly.com/v4/shorten'),
      headers: {
        'Authorization': 'aefa44714e69b96ef52308b8124cf2e31811ad86',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'long_url': url}),
    );

    if (!response.body.isEmpty) {
      Map<String, dynamic> body = jsonDecode(response.body);
      setState(() {
        shortUrl = body['link'];
      });
    } else {
      setState(() {
        shortUrl = 'An error occured';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(10),
          physics: BouncingScrollPhysics(),
          children: [
            SizedBox(
              height: 60,
            ),
            Text(
              'URL Shortener',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 60,
            ),
            CupertinoTextField(
              padding: const EdgeInsets.all(15),
              controller: url,
            ),
            const SizedBox(
              height: 10,
            ),
            CupertinoButton(
              child: const Text('Shorten'),
              color: Colors.black,
              onPressed: () => send(url.text),
            ),
            const SizedBox(height: 60),
            Text(
              'Shortened URL:',
              style: TextStyle(
                color: Colors.black,
                // fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                  flex: 6,
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(),
                    ),
                    child: SelectableText(
                      shortUrl,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: Icon(Icons.copy_rounded),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: shortUrl)).then(
                        (value) => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Link Copied to clipboard'),
                          ),
                        ),
                      );
                    },
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
