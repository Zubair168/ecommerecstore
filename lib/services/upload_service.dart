import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class UploadService {
  // Replace with your Cloudinary cloud name from dashboard
  static const _cloudName = 'z8ounlko';

  /// Uploads a file to Cloudinary using an unsigned preset.
  /// Returns the parsed JSON response on success.
  static Future<Map<String, dynamic>> uploadFile(
    File file, {
    String preset = 'notes_app',
  }) async {
    final uri = Uri.parse('https://api.cloudinary.com/v1_1/$_cloudName/upload');

    final request = http.MultipartRequest('POST', uri);
    request.fields['upload_preset'] = preset;

    final multipartFile = await http.MultipartFile.fromPath('file', file.path);
    request.files.add(multipartFile);

    final streamed = await request.send();
    final res = await http.Response.fromStream(streamed);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return json.decode(res.body) as Map<String, dynamic>;
    }

    throw Exception('Upload failed: ${res.statusCode} ${res.body}');
  }
}
