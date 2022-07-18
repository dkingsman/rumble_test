import 'dart:convert';

import 'package:rumble_blog/core/params/request_payload.dart';
import 'package:rumble_blog/core/resources/state.dart';
import 'package:rumble_blog/data/datasources/remote/ApiService.dart';
import 'package:rumble_blog/data/models/post_model.dart';
import 'package:rumble_blog/domain/repositories/article_repository.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final ApiServiceImpl _apiService;

  const ArticleRepositoryImpl(this._apiService);

  @override
  Future<DataState<List<Article>>> getArticles(
      RequestPayload requestPayload) async {
    try {
      final response = await _apiService.getArticles(requestPayload);
      final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      final UserPost post = UserPost.fromJson(decodedResponse);
      if (response.statusCode == 200 && post.data != null) {
        return DataSuccess(post.data ?? []);
      }
      return DataFailed("Failed to fetch:  ${response.body}");
    } catch (e) {
      return DataFailed(e.toString());
    }
  }
}
