import 'package:flutter/material.dart';

import '../../core/utils/helpers.dart';

class PostCard extends StatelessWidget {
  final String name;
  final String handle;
  final String articleTitle;
  final String articleSubtitle;
  final String imageAvataUrl;
  final String like;
  final String time;

  const PostCard(
      {Key? key,
      required this.name,
      required this.handle,
      required this.articleTitle,
      required this.articleSubtitle,
      required this.imageAvataUrl,
      required this.like,
      required this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: Colors.black87,
      ),
      height: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 1,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Image.network(imageAvataUrl),
                          ),
                          const Positioned(
                            bottom: 0,
                            right: 27,
                            child: Icon(
                              Icons.check_circle,
                              color: Colors.blue,
                              size: 15,
                            ),
                          )
                        ],
                      )),
                  Expanded(
                      flex: 4,
                      child: ListTile(
                        title: Text.rich(TextSpan(
                            text: " $name ",
                            style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                            children: <InlineSpan>[
                              TextSpan(
                                text: '@$name',
                                style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              )
                            ])),
                        subtitle: Text(
                          DateTime.now()
                              .toTimeAgoLabel(int.tryParse(time)!)
                              .toString(),
                          style: const TextStyle(color: Colors.white54),
                        ),
                        trailing: const Icon(
                          Icons.push_pin,
                          color: Colors.red,
                        ),
                      )),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Text(
                    articleTitle,
                    style: const TextStyle(color: Colors.white),
                  )),
                  Expanded(
                      child: Text(
                    articleSubtitle,
                    style: const TextStyle(color: Colors.white),
                  ))
                ],
              ),
            ),
          ),
          const Divider(
            height: 2.0,
            thickness: 0.5,
            color: Colors.white24,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(
                    Icons.thumb_up_sharp,
                    color: Colors.white24,
                    size: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      like,
                      style: const TextStyle(color: Colors.white54),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
