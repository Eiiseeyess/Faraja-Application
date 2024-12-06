// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'articles.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ArticleImpl _$$ArticleImplFromJson(Map<String, dynamic> json) =>
    _$ArticleImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      content: json['content'] as String?,
      link: json['link'] as String?,
      topic: json['topic'] as String,
      author: (json['author'] as num).toInt(),
      isTrending: json['isTrending'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$ArticleImplToJson(_$ArticleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'link': instance.link,
      'topic': instance.topic,
      'author': instance.author,
      'isTrending': instance.isTrending,
      'timestamp': instance.timestamp.toIso8601String(),
    };
