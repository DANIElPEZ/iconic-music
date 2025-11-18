import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<String?> downloadFile(String? url, String folder) async {
  if (url == null || url.isEmpty) return null;

  try {
    final uri = Uri.parse(url);
    final filename = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : null;
    if (filename == null || filename.isEmpty) return null;

    final dir = await getApplicationDocumentsDirectory();
    final folderDir = Directory('${dir.path}/$folder');

    if (!await folderDir.exists()) {
      await folderDir.create(recursive: true);
    }

    final filePath = '${folderDir.path}/$filename';

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return filePath;
    } else {
      print('Error descargando $url -> ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Excepción descargando $url -> $e');
    return null;
  }
}

Future<Map<String, dynamic>> downloadMusicFiles(Map<String, dynamic> music) async {
  final updated = Map<String, dynamic>.from(music);

  if (music['url_file'] != null && (music['url_file'] as String).isNotEmpty) {
    updated['local_music'] = await downloadFile(
      music['url_file'],
      'musics',
    );
  }

  if (music['url_image'] != null && (music['url_image'] as String).isNotEmpty) {
    updated['local_image'] = await downloadFile(
      music['url_image'],
      'images',
    );
  }

  if (music['url_lrc'] != null && (music['url_lrc'] as String).isNotEmpty) {
    updated['local_lrc'] = await downloadFile(
      music['url_lrc'],
      'lyrics',
    );

    updated['is_downloaded'] = 1;
  }

  return updated;
}
