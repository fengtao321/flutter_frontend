import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document.g.dart';

@JsonSerializable()
class Document {
  String? title;
  String? author;
  String? content;
  DateTime? date;
  List? subjects;

  Document({this.title, this.author, this.content, this.date, this.subjects});

  // Connect the generated [_$FormDataFromJson] function to the `fromJson`
  //factory.
  factory Document.fromJson(Map<String, dynamic> json) =>
      _$DocumentFromJson(json);

  //Connect the generated [_$FormDataToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$DocumentToJson(this);

  Widget buildTitle(BuildContext context) {
    return Text(
      title!,
    );
  }

  Widget buildAuthor(BuildContext context) {
    return Text(
      author!,
    );
  }

  Widget buildDate(BuildContext context) {
    return Text(
      date.toString(),
    );
  }

  bool isEmpty() {
    return title == null;
  }
}
