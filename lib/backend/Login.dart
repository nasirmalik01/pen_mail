import 'dart:convert';
import 'dart:io';

Future<String> loginUser({String username, String password}) async {
  final String apiUrl = 'https://dev.penmail.com.tr/api/Person/login';
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.postUrl(Uri.parse(apiUrl));
  request.headers.set('content-type', 'application/json');
  request.add(utf8.encode(
    jsonEncode(<String, String>{"username": username, "password": password}),
  ));
  HttpClientResponse response = await request.close();

  String reply = await response.transform(utf8.decoder).join();
  httpClient.close();
  var decodedReply = jsonDecode(reply);
  return reply;
}
