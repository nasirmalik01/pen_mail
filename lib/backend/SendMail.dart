import 'dart:io';
import 'package:http/http.dart' as http;


Future<String> sendMailWithAttachment(
    {String token, String fileName, String message}) async {
  // final String apiUrl = 'https://dev.penmail.com.tr/api/Attachment/Filespec';
  // HttpClient httpClient = new HttpClient();
  // HttpClientRequest request = await httpClient.postUrl(Uri.parse(apiUrl));
  // request.headers.set('content-type', 'multipart/form-data');
  // request.headers.set('person_token', token);
  //
  // request.add(utf8.encode(
  //   jsonEncode(
  //       <String, dynamic>{'Image': base64Encode(file.readAsBytesSync()), 'messages_id': messageId, 'message': message}),
  // ));
  // HttpClientResponse response = await request.close();
  // print('Status code : ${response.statusCode}');
  // String reply = await response.transform(utf8.decoder).join();
  // httpClient.close();
  // return reply;

  Map _headers = {
    'content-type': 'multipart/form-data',
    'person_token': token
  };

  var request = http.MultipartRequest('POST', Uri.parse('https://dev.penmail.com.tr/api/Attachment/Filespec'));
  request.headers.addAll(_headers);
  request.fields['messages_id'] = '1';
  request.fields['message'] = message;
  request.files.add(
      http.MultipartFile(
          'Image',
          File(fileName).readAsBytes().asStream(),
          File(fileName).lengthSync(),
          filename: fileName.split("/").last
      )
  );
  var res = await request.send();
  print(res.statusCode);
}