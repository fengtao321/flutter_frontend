// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'document.dart';

class FormWidgetsDemo extends StatefulWidget {
  const FormWidgetsDemo({super.key});

  @override
  State<FormWidgetsDemo> createState() => _FormWidgetsDemoState();
}

class _FormWidgetsDemoState extends State<FormWidgetsDemo> {
  final _formKey = GlobalKey<FormState>();
  var newFormat = DateFormat("yyyy-MM-dd");
  DateTime date = DateTime.now().toUtc();
  Document formData = Document();
  List multipleSelected = [];
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  List subjects = [
    {
      "id": 0,
      "value": false,
      "title": "Proposals",
    },
    {
      "id": 1,
      "value": false,
      "title": "Reports",
    },
    {
      "id": 2,
      "value": false,
      "title": "Research",
    }
  ];

  void _showDialog(String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Save your document'),
      ),
      body: Form(
        key: _formKey,
        child: Align(
          alignment: Alignment.topCenter,
          child: Card(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ...[
                      TextFormField(
                        decoration: const InputDecoration(
                          filled: true,
                          hintText: 'Enter a title...',
                          labelText: 'Title',
                        ),
                        onChanged: (value) {
                          setState(() {
                            formData.title = value;
                          });
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          filled: true,
                          hintText: 'Enter the author...',
                          labelText: 'Author',
                        ),
                        onChanged: (value) {
                          setState(() {
                            formData.author = value;
                          });
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          hintText: 'Enter the text content...',
                          labelText: 'Content',
                        ),
                        onChanged: (value) {
                          formData.content = value;
                        },
                        maxLines: 15,
                      ),
                      _FormDatePicker(
                        date: DateTime.now(),
                        onChanged: (value) {
                          setState(() {
                            formData.date = date.toUtc();
                          });
                        },
                      ),
                      Column(children: [
                        Text(
                          'Subjects',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        ...List.generate(
                          subjects.length,
                          (index) => CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            title: Text(
                              subjects[index]["title"],
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                            value: subjects[index]["value"],
                            onChanged: (value) {
                              setState(() {
                                subjects[index]["value"] = value;
                                if (multipleSelected
                                    .contains(subjects[index])) {
                                  multipleSelected.remove(subjects[index]);
                                } else {
                                  multipleSelected.add(subjects[index]);
                                }
                                formData.subjects = multipleSelected;
                              });
                            },
                          ),
                        ),
                      ]),
                      TextButton(
                        child: const Text('Submit'),
                        onPressed: () async {
                          // Use a JSON encoded string to send

                          var url = Uri.http('localhost:18080', '/v1/doc');
                          var response = await http.post(url,
                              headers: {'content-type': 'application/json'},
                              body: json.encode(formData.toJson()));
                          print('Response status: ${response.statusCode}');
                          print('Response body: ${response.body}');

                          _showDialog(switch (response.statusCode) {
                            202 => 'Successfully submitted.',
                            401 => 'Unable to sign in.',
                            _ => 'Something went wrong. Please try again.'
                          });
                        },
                      ),
                    ].expand(
                      (widget) => [
                        widget,
                        const SizedBox(
                          height: 24,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FormDatePicker extends StatefulWidget {
  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  const _FormDatePicker({
    required this.date,
    required this.onChanged,
  });

  @override
  State<_FormDatePicker> createState() => _FormDatePickerState();
}

class _FormDatePickerState extends State<_FormDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Date',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              intl.DateFormat.yMd().format(widget.date),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        TextButton(
          child: const Text('Edit'),
          onPressed: () async {
            var newDate = await showDatePicker(
              context: context,
              initialDate: widget.date,
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );

            // Don't change the date if the date picker returns null.
            if (newDate == null) {
              return;
            }

            widget.onChanged(newDate);
          },
        )
      ],
    );
  }
}
