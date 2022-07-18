import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ArticleLoadingState { busy, error }

class PostNotifier<T> extends StateNotifier<AsyncValue<List<T>>> {
  PostNotifier({
    required this.fetchNextArticle,
    required this.pageSize,
  }) : super(const AsyncValue.loading());

  ArticleLoadingState? status;
  final List<T> _articles = [];
  Timer _timer = Timer(const Duration(milliseconds: 0), () {});
  final int pageSize;
  final Future<List<T>> Function(T? article, String sortBy) fetchNextArticle;

  bool noMoreArticle = false;

  void initialize(String sortBy) {
    if (_articles.isEmpty) {
      fetchFirstPage(sortBy);
    }
  }

  void _updateArticle(List<T> result) {
    noMoreArticle = result.length < pageSize;
    if (result.isEmpty) {
      state = AsyncValue.data(_articles);
    } else {
      state = AsyncValue.data(_articles..addAll(result));
    }
  }

  Future<void> fetchFirstPage(String sortBy) async {
    try {
      state = const AsyncValue.loading();
      final List<T> result = _articles.isEmpty
          ? await fetchNextArticle(null, sortBy)
          : await fetchNextArticle(_articles.last, sortBy);
      _updateArticle(result);
    } catch (e, str) {
      log("Failed to fetch next page: $e", stackTrace: str);
      state = AsyncValue.error(e, stackTrace: str);
    }
  }

  Future<void> fetchNextPage(String sortBy) async {
    if (_timer.isActive && _articles.isNotEmpty) {
      return;
    }

    _timer = Timer(const Duration(milliseconds: 1000), () {});

    if (noMoreArticle) {
      return;
    }

    log("Fetching next batch of items");

    status = ArticleLoadingState.busy;
    state = AsyncValue.data(_articles);
    try {
      await Future.delayed(const Duration(seconds: 1));
      final result = await fetchNextArticle(_articles.last, sortBy);
      log(result.length.toString());
      _updateArticle(result);
    } catch (e, stk) {
      log("Error fetching next page", error: e, stackTrace: stk);
      status = ArticleLoadingState.error;
      state = AsyncValue.error(e, stackTrace: stk);
    }
  }
}
