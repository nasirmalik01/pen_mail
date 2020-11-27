// import 'dart:convert';
// import 'dart:io';
//
// import 'package:dio/dio.dart';
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';
//
// Future<String> addGuidebookAttachment(
//     {String token, File file, String filename, String groupId}) async {
//   // final String apiUrl = 'https://dev.penmail.com.tr/api/Attachment/Filespec';
//   // HttpClient httpClient = new HttpClient();
//   // HttpClientRequest request = await httpClient.postUrl(Uri.parse(apiUrl));
//   // request.headers.set('content-type', 'multipart/form-data');
//   // request.headers.set('person_token', token);
//   //
//   // request.add(utf8.encode(
//   //   jsonEncode(
//   //       <String, dynamic>{'Image': base64Encode(file.readAsBytesSync()), 'messages_id': messageId, 'message': message}),
//   // ));
//   // HttpClientResponse response = await request.close();
//   // print('Status code : ${response.statusCode}');
//   // String reply = await response.transform(utf8.decoder).join();
//   // httpClient.close();
//   // return reply;
//
//   Map<String, String> _headers = {
//     'content-type': 'multipart/form-data',
//     'person_token': token
//   };
//
//   // HttpClient httpClient = new HttpClient();
//   // HttpClientRequest request = await httpClient.postUrl(Uri.parse('https://dev.penmail.com.tr/api/Guidebook/AddWithGroup'));
//   // request.headers.set('content-type', 'multipart/form-data');
//   // request.headers.set('person_token', token);
//   //
//   // request.add(utf8.encode(
//   //   jsonEncode(
//   //       <String, dynamic>{'file': base64Encode(fileName.readAsBytesSync()), 'group_id': groupId,}),
//   // ));
//   // HttpClientResponse response = await request.close();
//   // print('Status code : ${response.statusCode}');
//   // String reply = await response.transform(utf8.decoder).join();
//   // httpClient.close();
//   // return reply;
//
//   // var request = http.MultipartRequest('POST', Uri.parse('https://dev.penmail.com.tr/api/Guidebook/AddWithGroup'));
//   // request.headers.addAll(_headers);
//   // request.fields['group_id'] = groupId;
//   // request.files.add(
//   //     http.MultipartFile(
//   //         'file',
//   //         File(fileName).readAsBytes().asStream(),
//   //         File(fileName).lengthSync(),
//   //         filename: fileName.split("/").last,
//   //     )
//   // );
//   // var res = await request.send();
//   // print(res.statusCode);
//
//   Dio dio = new Dio();
//   try {
//     FormData formdata = new FormData.fromMap({
//       'file': await MultipartFile.fromFile(file.path,
//           filename: filename, contentType: MediaType('file', 'xlsx')),
//       'type': 'file/xlsx'
//     });
//     Response response = await dio.post(
//         'https://dev.penmail.com.tr/api/Guidebook/AddWithGroup', data: formdata,
//         options: Options(
//             headers: {
//               'content-type': 'multipart/form-data',
//               'person_token': token
//             }
//         ));
//     return response;
//   }catch(e){
//
//   }
// }
