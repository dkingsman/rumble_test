import 'package:rumble_blog/core/params/request_payload.dart';
import 'package:rumble_blog/core/resources/state.dart';
import 'package:rumble_blog/core/usecases/usecase.dart';
import 'package:rumble_blog/data/models/post_model.dart';
import 'package:rumble_blog/domain/repositories/article_repository.dart';

class GetArticleUseCase
    implements UseCase<DataState<List<Article>>, RequestPayload> {
  final ArticleRepository _articleRepository;

  GetArticleUseCase(this._articleRepository);

  @override
  Future<DataState<List<Article>>> call({RequestPayload? params}) {
    return _articleRepository.getArticles(params!);
  }
}
