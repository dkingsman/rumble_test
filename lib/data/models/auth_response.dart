class AuthResponse {
  Result? result;

  AuthResponse({this.result});

  AuthResponse.fromJson(Map<String, dynamic> json) {
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class Result {
  String? username;
  String? email;
  int? userId;
  String? uniqueId;
  String? ssAuthToken;
  int? activeSubscriber;
  int? unclaimedGift;

  Result(
      {this.username,
      this.email,
      this.userId,
      this.uniqueId,
      this.ssAuthToken,
      this.activeSubscriber,
      this.unclaimedGift});

  Result.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    userId = json['user_id'];
    uniqueId = json['unique_id'];
    ssAuthToken = json['ss_auth_token'];
    activeSubscriber = json['active_subscriber'];
    unclaimedGift = json['unclaimed_gift'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['email'] = email;
    data['user_id'] = userId;
    data['unique_id'] = uniqueId;
    data['ss_auth_token'] = ssAuthToken;
    data['active_subscriber'] = activeSubscriber;
    data['unclaimed_gift'] = unclaimedGift;
    return data;
  }
}
