import 'dart:convert';
import 'dart:io';

Future<String> getSignatureList({String token}) async {
  final String apiUrl = 'https://dev.penmail.com.tr/api/Signature/Getlist';
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

Future<String> addSignature({String token, String signatureName, String signatureContent}) async {
  final String apiUrl = 'https://dev.penmail.com.tr/api/Signature/add';
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.postUrl(Uri.parse(apiUrl));
  request.headers.set('content-type', 'application/json');
  request.headers.set('person_token', token);
  request.add(utf8.encode(
    jsonEncode(<String, String>{
      'name': signatureName,
      'content': signatureContent,
    }),
  ));
  HttpClientResponse response = await request.close();
  String reply = await response.transform(utf8.decoder).join();
  httpClient.close();
  return reply;
}