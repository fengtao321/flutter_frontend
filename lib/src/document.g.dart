// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Document _$DocumentFromJson(Map<String, dynamic> json) => Document(
      title: json['title'] as String?,
      author: json['author'] as String?,
      content: json['content'] as String?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      subjects: json['subjects'] as List<dynamic>?,
    );

Map<String, dynamic> _$DocumentToJson(Document instance) => <String, dynamic>{
      'title': instance.title,
      'author': instance.author,
      'content': instance.content,
      'date': instance.date?.toIso8601String(),
      'subjects': instance.subjects,
    };
