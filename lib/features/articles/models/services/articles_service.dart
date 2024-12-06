import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../../local_storage/local_storage.dart';
import '../../../../utils/utils.dart';
import '../core/articles.dart';
import 'package:http/http.dart' as http;

class ArticleService {
  Future<Either<String, Article>> postArticle({
    required String title,
    required String content,
    required String topic,
    required bool isTrending,
  }) async {
    try {
      // Retrieve the access token
      TokenPair? tokenPair = await LocalStorage.getToken();
      if (tokenPair == null) {
        return const Left('No tokens found, user might not be logged in');
      }

      // Define the request body
      final Map<String, dynamic> requestBody = {
        "title": title,
        "content": content,
        "topic": topic,
        "is_trending": isTrending,
      };

      // Send the POST request
      final response = await http.post(
        Uri.parse("${Constants.BASE_URL}/articles/post/"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${tokenPair.access}",
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        // Parse the response body
        final jsonData = jsonDecode(response.body);
        final article = Article.fromJson(jsonData);
        return Right(article);
      } else {
        // Handle server errors
        debugPrint("Error posting article: ${response.body}");
        return Left(
            'Failed to post article. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle unexpected errors
      debugPrint('Error posting article: $e');
      return Left('Error posting article: $e');
    }
  }

  Future<Either<String, List<Article>>> fetchArticles() async {
    try {
      // Retrieve the access token
      TokenPair? tokenPair = await LocalStorage.getToken();
      if (tokenPair == null) {
        return const Left('No tokens found, user might not be logged in');
      }

      // Send the GET request
      final response = await http.get(
        Uri.parse("${Constants.BASE_URL}/articles/"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${tokenPair.access}",
        },
      );

      if (response.statusCode == 200) {
        // Parse the response body
        final List<dynamic> jsonData = jsonDecode(response.body);
        final List<Article> articles = jsonData
            .map((articleJson) => Article.fromJson(articleJson))
            .toList();
        return Right(articles);
      } else {
        // Handle server errors
        debugPrint("Error fetching articles: ${response.body}");
        return Left(
            'Failed to fetch articles. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle unexpected errors
      debugPrint('Error fetching articles: $e');
      return Left('Error fetching articles: $e');
    }
  }

  Future<Either<String, Article>> fetchArticleById(int articleId) async {
    try {
      // Retrieve the access token
      TokenPair? tokenPair = await LocalStorage.getToken();
      if (tokenPair == null) {
        return const Left('No tokens found, user might not be logged in');
      }

      // Send the GET request to fetch the article by its ID
      final response = await http.get(
        Uri.parse("${Constants.BASE_URL}/articles/$articleId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${tokenPair.access}",
        },
      );

      if (response.statusCode == 200) {
        // Parse the response body
        final jsonData = jsonDecode(response.body);
        final article = Article.fromJson(jsonData);
        return Right(article);
      } else {
        // Handle server errors
        debugPrint("Error fetching article: ${response.body}");
        return Left(
            'Failed to fetch article. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle unexpected errors
      debugPrint('Error fetching article: $e');
      return Left('Error fetching article: $e');
    }
  }
}
