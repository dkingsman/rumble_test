class RequestPayload {
  RequestData? requestData;

  RequestPayload({this.requestData});

  RequestPayload.fromJson(Map<String, dynamic> json) {
    requestData =
        json['data'] != null ? RequestData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (requestData != null) {
      data['data'] = requestData!.toJson();
    }
    return data;
  }
}

class RequestData {
  int? pageSize;
  String? order;
  int? lpid;

  RequestData({this.pageSize, this.order, this.lpid});

  RequestData.fromJson(Map<String, dynamic> json) {
    pageSize = json['page_size'];
    order = json['order'];
    lpid = json['lpid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page_size'] = pageSize;
    data['order'] = order;
    data['lpid'] = lpid;
    return data;
  }
}
