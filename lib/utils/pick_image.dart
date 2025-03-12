import 'package:image_picker/image_picker.dart';
import 'package:qr_code_scanner/utils/show_snackBar.dart';

Future<String?> pickImageFromGallery() async {
  try {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    return image.path;
  } catch (e) {
    showSnackBar("Eror: $e");
    return null;
  }
}
