import 'dart:typed_data';
import 'package:sigede_movil/config/dio_client.dart';
import 'package:dio/dio.dart';

class CloudinaryService {
  static const String cloudName = 'dpkl7ms3o';
  static const uploadPreset = 'dpkl7ms3o-sigede';
  static const String url = 'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

  static Future<String> uploadImage(Uint8List imageBytes, String fileName) async {
    try{
      FormData formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          imageBytes,
          filename: fileName,
        ),
        'upload_preset': uploadPreset,
      });
      DioClient dioClient = DioClient();
      final response = await dioClient.dio.post(url, data: formData);
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