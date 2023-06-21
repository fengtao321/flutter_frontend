// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'document.dart';

class SearchWidgetsDemo extends StatefulWidget {
  const SearchWidgetsDemo({super.key});

  @override
  State<SearchWidgetsDemo> createState() => _SearchWidgetsDemo();
}

class _SearchWidgetsDemo extends State<SearchWidgetsDemo> {
  List<dynamic> _documentList = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elasticsearch Demo',
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Search'),
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
                      hintText: 'Enter a search term',
                    ),
                    onChanged: (String value) async {
                      var url = Uri.http(dotenv.env['URL']!, '/v1/doc/search',
                          {'searchText': value});
                      var response = await http.get(url, headers: {
                        HttpHeaders.contentTypeHeader: 'application/json'
                      });
                      setState(() => _documentList = jsonDecode(response.body));
                    },
                  ),
                  if (_documentList.length > 0)
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      // Let the ListView know how many items it needs to build.
                      itemCount: _documentList.length,
                      // Provide a builder function. This is where the magic happens.
                      // Convert each item into a widget based on the type of item it is.
                      itemBuilder: (context, index) {
                        print(_documentList);
                        final item = Document.fromJson(_documentList[index]);
                        print(item);
                        return Center(
                          widthFactor: 300,
                          // color: Colors.blue,
                          child: ListTile(
                            leading: Icon(Icons.account_circle),
                            title: item.buildTitle(context),
                            subtitle: item.buildAuthor(context),
                            trailing: Icon(Icons.arrow_forward),
                          ),
                        );
                      },
                    )
                  else
                    const Text("Nothing Is Not Funny")
                ],
              ),
            ),
          )),
    );
  }
  // );
}
