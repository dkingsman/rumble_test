import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rumble_blog/core/resources/state.dart';

import '../../core/params/request_payload.dart';
import '../../data/datasources/remote/ApiService.dart';
import '../../data/models/post_model.dart';
import '../../data/repositories/article_repository_impl.dart';
import '../../domain/usecases/get_article_usecase.dart';
import '../notifier/post_notifier.dart';

//api service
final apiService = Provider<ApiServiceImpl>((ref) {
  return ApiServiceImpl();
});

//repository
final articleRepositoryProvider = Provider<ArticleRepositoryImpl>((ref) {
  final apiClient = ref.watch(apiService);
  return ArticleRepositoryImpl(apiClient);
});

//use-cases
final useCasesProvider = Provider((ref) {
  return GetArticleUseCase(ref.watch(articleRepositoryProvider));
});

//article provider
final articlesProvider =
    StateNotifierProvider<PostNotifier<Article>, AsyncValue<List<Article>>>(
        (ref) {
  return PostNotifier(
    fetchNextArticle: (article, sortBy) async {
      print(article?.id ?? 1);

      final state = await ref.read(useCasesProvider).call(
          params: RequestPayload(
              requestData: RequestData(
                  pageSize: 10, order: sortBy, lpid: article?.id ?? 1)));

      if (state is DataSuccess && state.data!.isNotEmpty) {
        return state.data!;
      }

      return [];
    },
    pageSize: 10,
  )..initialize("recent");
});
