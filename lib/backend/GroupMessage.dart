
import 'dart:convert';
import 'dart:io';

Future<String> sendGroupMessage({String token, int messageId, int groupId}) async {
  List<Map<String, int>> products = [
    {
      "group_id": groupId,
      "messages_id": messageId,

    }
  ];
  final String apiUrl = 'https://dev.penmail.com.tr/api/GuidebookGroups/add';
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.postUrl(Uri.parse(apiUrl));
  request.headers.set('content-type', 'application/json');
  request.headers.set('person_token', token);

  request.add(utf8.encode(
    jsonEncode(products),
  ));
  HttpClientResponse response = await request.close();
  print(response.statusCode);
  String reply = await response.transform(utf8.decoder).join();
  httpClient.close();
  return reply;
}