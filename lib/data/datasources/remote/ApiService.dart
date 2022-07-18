import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rumble_blog/core/params/request_payload.dart';
import 'package:rumble_blog/data/models/auth_response.dart';

import '../../../core/utils/constants.dart';

abstract class ApiService {
  Future<http.Response> getArticles(RequestPayload requestData);

  Future<http.Response?> authenticate(String deviceId, String username, email);
}

class ApiServiceImpl implements ApiService {
  ApiServiceImpl();

  final client = http.Client();

  @override
  Future<http.Response> getArticles(RequestPayload payload) async {
    String deviceId = userDeviceId;
    String email = 'testlocals0@gmail.com';
    String password = 'jahubhsgvd23';
    http.Response? postResponse;

    try {
      await authenticate(deviceId, password, email).then((response) async {
        final decodedResponse = jsonDecode(response.body);
        AuthResponse auth = AuthResponse.fromJson(decodedResponse);
        if (response.statusCode == 200 && response.body.isNotEmpty) {
          final headers = {
            "Accept": "application/json",
            'Content-Type': 'application/json;charset=UTF-8',
            'Charset': 'utf-8',
            "X-APP-AUTH-TOKEN": auth.result!.ssAuthToken ?? '',
            "X-DEVICE-ID": deviceId,
          };

          final params = {
            "data": {
              "page_size": payload.requestData!.pageSize,
              "order": payload.requestData!.order,
              "lpid": payload.requestData!.lpid,
            }
          };

          try {
            final url = Uri.parse(baseUrl + postEndpoint);
            postResponse = await client.post(url,
                headers: headers, body: jsonEncode(params));
          } catch (e, stk) {
            throw "API request error: ${e.toString()} ${stk.toString()}";
          }
        } else {
          throw "Authentication failed";
        }
      });
      return postResponse!;
    } catch (e, stk) {
      throw "Error ${e.toString()} ${stk.toString()}";
    }
  }

  @override
  Future<http.Response> authenticate(
      String deviceId, String password, email) async {
    final params = {
      'grant_type': 'password',
      "device_id": deviceId,
      "password": password,
      "email": email
    };
    try {
      final url = Uri.parse(baseUrl + authEndpoint);
      final response = await client.post(url, body: params);
      return response;
    } on Exception catch (e) {
      client.close();
      throw "API request error: ${e.toString()}";
    }
  }
}
