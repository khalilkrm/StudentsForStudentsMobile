import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class ApplicationImagePicker {
  final ImagePicker _imagePicker = ImagePicker();
  File? _pickedImage;
  File? get pickedImage => _pickedImage;

  Future<ApplicationImagePickerResult?> pickImageFromGallery() async {
    return await _pickImage(ImageSource.gallery);
  }

  Future<ApplicationImagePickerResult?> pickImageFromCamera() async {
    return await _pickImage(ImageSource.camera);
  }

  Future<ApplicationImagePickerResult?> _pickImage(ImageSource source) async {
    final pickedImage = await _imagePicker.pickImage(source: source);
    if (pickedImage == null) return null;
    return ApplicationImagePickerResult(File(pickedImage.path));
  }
}

class ApplicationImagePickerResult {
  final File _pickedImage;
  File get pickedImage => _pickedImage;

  ApplicationImagePickerResult(this._pickedImage);

  String get extension => path.extension(_pickedImage.path);

  Future<Uint8List> toBytes() async {
    return await _pickedImage.readAsBytes();
  }
}
