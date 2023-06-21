// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'document.dart';

class SearchTitleWidgetsDemo extends StatefulWidget {
  const SearchTitleWidgetsDemo({super.key});

  @override
  State<SearchTitleWidgetsDemo> createState() => _SearchTitleWidgetsDemo();
}

class _SearchTitleWidgetsDemo extends State<SearchTitleWidgetsDemo> {
  Document _documentList = new Document();
  String title = "";
  String author = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elasticsearch Demo',
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Search Title and Author'),
          ),
          body: Align(
            alignment: FractionalOffset.center,
            child: Container(
              width: 600,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter the  title',
                    ),
                    onChanged: (String value) async {
                      title = value;
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter the  author',
                    ),
                    onChanged: (String value) async {
                      author = value;
                    },
                  ),
                  TextButton(
                    child: const Text('Submit'),
                    onPressed: () async {
                      var url = Uri.http(dotenv.env['URL']!,
                          '/v1/doc/' + title + '/{author}', {'author': author});
                      var response = await http.get(url, headers: {
                        HttpHeaders.contentTypeHeader: 'application/json'
                      });
                      print(response.body);
                      setState(() => _documentList =
                          Document.fromJson(jsonDecode(response.body)));
                    },
                  ),
                  if (_documentList.isEmpty())
                    const Text("Nothing Is Not Funny")
                  else
                    Center(
                      widthFactor: 300,
                      // color: Colors.blue,
                      child: ListTile(
                        leading: Icon(Icons.account_circle),
                        title: _documentList.buildTitle(context),
                        subtitle: _documentList.buildAuthor(context),
                        trailing: Icon(Icons.arrow_forward),
                      ),
                    )
                ],
              ),
            ),
          )),
    );
  }
  // );
}

// http://localhost:18080/v1/doc/search/string/%7Bauthor%7D?author=string 404
// http://localhost:18080/v1/doc/sdfd/%7Bauthor%7D?author=s
