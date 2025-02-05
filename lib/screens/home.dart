import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gender_app/model/gender.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var name = '';

  @override
  void initState() {
    // initState implementation
    super.initState();
    fetchData(name);
  }

  Gender data = Gender(count: 0, name: '', type: '');

  @override
  Widget build(BuildContext context) {
    debugPrint(data.count.toString());
    debugPrint("Gender is ${data.type}");
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  decoration: const InputDecoration(hintText: "Enter a name"),
                  onSubmitted: (value) => setState(
                    () {
                      name = value;
                      fetchData(name);
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "${data.type}",
                style: const TextStyle(fontSize: 20),
              )
            ],
          ),
        ),
      ),
    );
  }

  void fetchData(String name) async {
    final url = 'https://api.genderize.io?name=$name';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    final transformed = Gender(
        count: json['count'],
        name: json['name'],
        type: json['gender'] ?? 'unknown');
    setState(() {
      data = transformed;
    });
  }
}
