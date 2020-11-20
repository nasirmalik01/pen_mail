import 'dart:convert';
import 'dart:io';

Future<String> getGuideBook({String token}) async {
  final String apiUrl = 'https://dev.penmail.com.tr/api/Guidebook/Getlist';
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.postUrl(Uri.parse(apiUrl));
  request.headers.set('content-type', 'application/json');
  request.headers.set('person_token', token);
  request.add(utf8.encode(
    jsonEncode(<String, String>{}),
  ));
  HttpClientResponse response = await request.close();
  String reply = await response.transform(utf8.decoder).join();
  httpClient.close();
  return reply;
}

Future<String> addGuideBook(
    {String token, String surname, String email, String gsm}) async {
  final String apiUrl = 'https://dev.penmail.com.tr/api/Guidebook/add';
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.postUrl(Uri.parse(apiUrl));
  request.headers.set('content-type', 'application/json');
  request.headers.set('person_token', token);
  request.add(utf8.encode(
    jsonEncode(
        <String, dynamic>{'name_surname': surname, 'gsm': gsm, 'email': email}),
  ));
  HttpClientResponse response = await request.close();
  String reply = await response.transform(utf8.decoder).join();
  httpClient.close();
  return reply;
}

Future<String> updateGuideBook(
    {String token, int id, String surname, String gsm, String email}) async {
  final String apiUrl = 'https://dev.penmail.com.tr/api/Guidebook/update';
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.postUrl(Uri.parse(apiUrl));
  request.headers.set('content-type', 'application/json');
  request.headers.set('person_token', token);
  request.add(utf8.encode(
    jsonEncode(<String, dynamic>{
      'id': id,
      'name_surname': surname,
      'gsm': gsm,
      'email': email
    }),
  ));
  HttpClientResponse response = await request.close();
  String reply = await response.transform(utf8.decoder).join();
  httpClient.close();
  return reply;
}
