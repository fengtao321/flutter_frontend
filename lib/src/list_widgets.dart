// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'document.dart';

class ListWidgetsDemo extends StatefulWidget {
  const ListWidgetsDemo({super.key});

  @override
  State<ListWidgetsDemo> createState() => _ListWidgetsDemoState();
}

class _ListWidgetsDemoState extends State<ListWidgetsDemo> {
  Future<dynamic> getDocumentList() async {
    // do something here
    var url = Uri.http('localhost:18080', '/v1/doc');
    final response = await http
        .get(url, headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    print("response body:");
    print(response.body);
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<dynamic>(
        future: getDocumentList(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return Material(
              child: ListView.builder(
                // Let the ListView know how many items it needs to build.
                itemCount: snapshot.data.length,
                // Provide a builder function. This is where the magic happens.
                // Convert each item into a widget based on the type of item it is.
                itemBuilder: (context, index) {
                  final item = Document.fromJson(snapshot.data[index]);

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
              ),
            );
          } else if (snapshot.hasError) {
            print('ERROR');
          }

          // By default, show a loading spinner
          return CircularProgressIndicator();
        },
      );
}
