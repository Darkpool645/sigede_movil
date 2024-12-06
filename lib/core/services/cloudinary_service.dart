import 'dart:typed_data';
import 'package:dio/dio.dart';

class CloudinaryService {
  final Dio dio;

  CloudinaryService({Dio? dio}) : dio = dio ?? Dio();

  Future<String?> uploadImage(Uint8List imageBytes, String fileName) async {
    const String cloudName = 'dpkl7ms3o';
    const String uploadPreset = 'dpkl7ms3o-sigede';
    const String url = 'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

    try {
      FormData formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(imageBytes, filename: '$fileName.jpg'),
        'upload_preset': uploadPreset,
      });
      final response = await dio.post(url, data: formData);

      if (response.statusCode == 200) {
        return response.data['secure_url'];
      } else {
        throw Exception('Error al subir la imagen');
      }
    } catch (e) {
      throw Exception('Error al subir la imagen: $e');
    }
  }
}