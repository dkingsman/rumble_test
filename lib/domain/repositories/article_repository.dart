import 'package:rumble_blog/core/params/request_payload.dart';
import 'package:rumble_blog/core/resources/state.dart';
import 'package:rumble_blog/data/models/post_model.dart';

abstract class ArticleRepository {
  Future<DataState<List<Article>>> getArticles(RequestPayload requestData);
}
