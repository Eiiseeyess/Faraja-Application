import 'package:freezed_annotation/freezed_annotation.dart';

part 'articles.freezed.dart';
part 'articles.g.dart';

@freezed
class Article with _$Article {
  factory Article({
    required int id,
    required String title,
    String? content, 
    String? link,    
    required String topic,
    required int author, 
    required bool isTrending,
    required DateTime timestamp,
  }) = _Article;

  factory Article.fromJson(Map<String, dynamic> json) => _$ArticleFromJson(json);
}
