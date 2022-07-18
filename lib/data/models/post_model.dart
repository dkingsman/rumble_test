class UserPost {
  int? status;
  String? code;
  List<Article>? data;

  UserPost({this.status, this.code, this.data});

  UserPost.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    if (json['data'] != null) {
      data = <Article>[];
      json['data'].forEach((v) {
        data!.add(Article.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Article {
  int? id;
  int? authorId;
  int? communityId;
  String? text;
  String? title;
  bool? likedByUs;
  bool? commentedByUs;
  bool? bookmarked;
  int? timestamp;
  int? totalPostViews;
  bool? isBlured;
  String? authorName;
  String? authorAvatarExtension;
  String? authorAvatarUrl;

  Article(
      {this.id,
      this.authorId,
      this.communityId,
      this.text,
      this.title,
      this.likedByUs,
      this.commentedByUs,
      this.bookmarked,
      this.timestamp,
      this.totalPostViews,
      this.isBlured,
      this.authorName,
      this.authorAvatarExtension,
      this.authorAvatarUrl});

  Article.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    authorId = json['author_id'];
    communityId = json['community_id'];
    text = json['text'];
    title = json['title'];
    likedByUs = json['liked_by_us'];
    commentedByUs = json['commented_by_us'];
    bookmarked = json['bookmarked'];
    timestamp = json['timestamp'];
    totalPostViews = json['total_post_views'];
    isBlured = json['is_blured'];
    authorName = json['author_name'];
    authorAvatarExtension = json['author_avatar_extension'];
    authorAvatarUrl = json['author_avatar_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['author_id'] = this.authorId;
    data['community_id'] = this.communityId;
    data['text'] = this.text;
    data['title'] = this.title;
    data['liked_by_us'] = this.likedByUs;
    data['commented_by_us'] = this.commentedByUs;
    data['bookmarked'] = this.bookmarked;
    data['timestamp'] = this.timestamp;
    data['total_post_views'] = this.totalPostViews;
    data['is_blured'] = this.isBlured;
    data['author_name'] = this.authorName;
    data['author_avatar_extension'] = this.authorAvatarExtension;
    data['author_avatar_url'] = this.authorAvatarUrl;
    return data;
  }
}
