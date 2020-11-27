import 'dart:convert';
import 'dart:io';



Future<String> addGroupInGuideBook(
    {String token, int groupId, int guideId}) async {
  List<Map<String,dynamic>> products =  [
    {
      "guidebook_id": guideId,
      "groups_id": groupId,

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


Future<String> addingGuideBooksInGroups({String token}) async {
  final String apiUrl = 'https://dev.penmail.com.tr/api/GuidebookGroups/Getlist';
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.postUrl(Uri.parse(apiUrl));
  request.headers.set('content-type', 'application/json');
  request.headers.set('person_token', token);
  request.add(utf8.encode(
    jsonEncode(<String, String>{}),
  ));
  HttpClientResponse response = await request.close();
  print(response.statusCode);
  String reply = await response.transform(utf8.decoder).join();
  httpClient.close();
  return reply;
}
