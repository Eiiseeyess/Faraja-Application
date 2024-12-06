import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:hackathon_frontend/features/articles/models/core/articles.dart';
import 'package:hackathon_frontend/features/articles/models/services/articles_service.dart';

class ArticleController extends GetxController {
  final ArticleService _articleService = ArticleService();

  var isLoading = false.obs;
  var postedArticle = Rxn<Article>();

  Future<Either<String, Article>> postArticle({
    required String title,
    required String content,
    required String topic,
    required bool isTrending,
  }) async {
    isLoading.value = true;

    // Call the service method
    final result = await _articleService.postArticle(
      title: title,
      content: content,
      topic: topic,
      isTrending: isTrending,
    );

    isLoading.value = false;

    return result.fold((l) {
      return left(l);
    }, (r) {
      return right(r);
    });
  }

  Future<Either<String, List<Article>>> fetchArticles() async {
    isLoading(true);
    final result = await _articleService.fetchArticles();

    isLoading(false);

    return result.fold((l) {
      return left(l);
    }, (r) {
      return right(r);
    });
  }

  Future<Either<String, Article>> fetchArticleById(int articleId) async {
    
      isLoading.value = true;

      final result = await _articleService.fetchArticleById(articleId);

      return result.fold((l) {
      return left(l);
    }, (r) {
      return right(r);
    });
    
  }
}
