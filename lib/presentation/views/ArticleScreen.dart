import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rumble_blog/core/utils/constants.dart';
import 'package:rumble_blog/presentation/notifier/post_notifier.dart';
import 'package:rumble_blog/presentation/widgets/post_card.dart';

import '../../data/models/post_model.dart';
import '../di/providers.dart';

class ArticleScreen extends ConsumerStatefulWidget {
  const ArticleScreen({Key? key}) : super(key: key);

  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends ConsumerState<ArticleScreen> {
  final Connectivity _connectivity = Connectivity();
  late ConnectivityResult _connectivityResult = ConnectivityResult.none;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final ScrollController _scrollController = ScrollController();

  String _sortByFilter = Order.recent.name;

  List<String> sortByItems = [Order.recent.name, Order.olders.name];

  bool connected = false;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _checkConnection();
    });
  }

  _checkConnection() async {
    _connectivityResult = await _connectivity.checkConnectivity();
    if (_connectivityResult == ConnectivityResult.mobile ||
        _connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        connected = true;
      });
    } else {
      setState(() {
        connected = false;
      });
      _showSnackBar();
    }
  }

  _showSnackBar() {
    const SnackBar snackBar =
        SnackBar(content: Text("You are not connected to the internet"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    _checkConnection();
    setState(() {
      _connectivityResult = result;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.width * 0.20;
      if (maxScroll - currentScroll <= delta) {
        ref.read(articlesProvider.notifier).fetchNextPage(_sortByFilter);
      }
    });
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('Rumble'),
        actions: [
          Row(
            children: [
              const Text('Sortby:'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _sortByFilter,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white,
                    ),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black, fontSize: 18),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (data) {
                      setState(() {
                        _sortByFilter = data!;
                      });
                    },
                    items: sortByItems
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              )
            ],
          )
        ],
      ),
      body: CustomScrollView(
        controller: _scrollController,
        restorationId: 'Article List',
        slivers: [
          ItemsList(sortBy: _sortByFilter),
          const NoMoreArticles(),
          const BusyLoadingWidget()
        ],
      ),
    ));
  }
}

class ItemsList extends StatelessWidget {
  const ItemsList({Key? key, required this.sortBy}) : super(key: key);
  final String sortBy;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(articlesProvider);
      return state.when(
        data: (articles) {
          return articles.isEmpty
              ? SliverToBoxAdapter(
                  child: Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          ref
                              .read(articlesProvider.notifier)
                              .fetchFirstPage(sortBy);
                        },
                        icon: const Icon(Icons.replay),
                      ),
                      const Chip(
                        label: Text("No items Found!"),
                      ),
                    ],
                  ),
                )
              : ArticleItemBuilder(
                  articles: articles,
                );
        },
        loading: () => const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator())),
        error: (e, stk) => SliverToBoxAdapter(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Icon(Icons.info),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Something Went Wrong!",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class BusyLoadingWidget extends StatelessWidget {
  const BusyLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(40),
      sliver: SliverToBoxAdapter(
        child: Consumer(builder: (context, ref, child) {
          final state = ref.watch(articlesProvider);
          return state.maybeWhen(
              orElse: () => const SizedBox.shrink(),
              data: (articles) {
                final noMoreArticle =
                    ref.read(articlesProvider.notifier).status;
                return noMoreArticle == ArticleLoadingState.busy
                    ? const Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Text(
                          "Loading more article",
                          textAlign: TextAlign.center,
                        ),
                      )
                    : noMoreArticle == ArticleLoadingState.error
                        ? const Text('An error has occured')
                        : const SizedBox.shrink();
              });
        }),
      ),
    );
  }
}

class ArticleItemBuilder extends StatelessWidget {
  const ArticleItemBuilder({Key? key, required this.articles})
      : super(key: key);

  final List<Article> articles;

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
      final article = articles[index];
      return PostCard(
        name: article.authorName!,
        imageAvataUrl: article.authorAvatarUrl!,
        time: article.timestamp.toString(),
        articleSubtitle: article.title!,
        handle: article.authorId.toString(),
        articleTitle: article.text!,
        like: article.totalPostViews.toString(),
      );
    }, childCount: articles.length));
  }
}

class NoMoreArticles extends ConsumerWidget {
  const NoMoreArticles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(articlesProvider);

    return SliverToBoxAdapter(
      child: state.maybeWhen(
          orElse: () => const SizedBox.shrink(),
          data: (articles) {
            final noMoreArticle =
                ref.read(articlesProvider.notifier).noMoreArticle;
            return noMoreArticle
                ? const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      "No More Items Found!",
                      textAlign: TextAlign.center,
                    ),
                  )
                : const SizedBox.shrink();
          }),
    );
  }
}
