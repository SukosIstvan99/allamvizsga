import 'dart:convert';
import 'dart:io';
import 'package:allamvizsga/models/responses/upload_img_response.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:allamvizsga/network/constants.dart' as constant;



class ApiClient {
  ApiClient({required this.client});


  final http.Client client;
  final String url = constant.cim;

  // API nevek
  final String _profilePath = 'profile.php';
  final String _uploadimgPath = 'upload_profile_picture.php';
  final String _uploadReportImgPath = 'upload_report_picture.php';
  final String _sharePath = '/share.php';

  // Field nevek
  final String _udidField = 'udid';
  final String _idField = 'id';
  final String _uidField = 'userId';
  final String _dataField = 'data';

  Future<Map<String, dynamic>> _post(
      {required String path, required Map<String, dynamic> arguments}) async {
    http.Response response = await client.post(
        Uri.parse(url + path), body: arguments);
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> _postMultipart(
      {required String path,
        required Map<String, String> arguments,
        required List<http.MultipartFile> files}) async {
    final String urla = '$url$path';
    final http.MultipartRequest multipartRequest =
    http.MultipartRequest('POST', Uri.parse(urla))
      ..fields.addAll(arguments)
      ..files.addAll(files);
    final http.StreamedResponse response = await multipartRequest.send();
    final String responseJsonString = utf8.decode(await response.stream.toBytes());
    return jsonDecode(responseJsonString);
  }

  Future<List<http.MultipartFile>> _buildImageFiles(
      {required String key,
        required List<String> path,
        required MediaType contentType}) async {
    final List<http.MultipartFile> files = [];
    for (int i = 0; i < path.length; i++) {
      if(File.fromUri(Uri.parse(path[i])).existsSync()){
        files.add(await http.MultipartFile.fromPath(
          key, //+ i.toString(),
          Uri.parse(path[i]).toFilePath(),
          contentType: contentType,
          filename: path[i].substring(path[i].lastIndexOf('/') + 1),
        ));
      }
    }
    return files;
  }




  Future<UploadImgResponse> uploadCameraPhoto({required String uid, required List<String> files}) async {
    return UploadImgResponse.fromJson(await _postMultipart(
        path: _uploadimgPath,
        arguments: <String, String>{
          _uidField: uid,
        },
        files: await _buildImageFiles(
            key: 'profilePicture',
            path: files,
            contentType: MediaType('image', 'png'))
    ));
  }

  Future<UploadImgResponse> uploadReportPhoto({required String uid, required List<String> files}) async {
    return UploadImgResponse.fromJson(await _postMultipart(
        path: _uploadReportImgPath,
        arguments: <String, String>{

        },
        files: await _buildImageFiles(
            key: 'profilePicture',
            path: files,
            contentType: MediaType('image', 'png'))
    ));
  }

}