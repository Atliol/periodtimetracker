import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CommunityMediaService {
  static const int _maxEncodedLength = 850 * 1024;
  static final ImagePicker _picker = ImagePicker();

  static Future<String?> pickPhoto({
    int maxWidth = 720,
    int maxHeight = 720,
    int imageQuality = 55,
  }) async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: imageQuality,
      maxWidth: maxWidth.toDouble(),
      maxHeight: maxHeight.toDouble(),
    );
    if (file == null) return null;

    final encoded = base64Encode(await file.readAsBytes());
    if (encoded.length > _maxEncodedLength) {
      throw StateError('ပုံအရွယ်အစားကြီးလွန်းပါသည်။ ပိုသေးသောပုံကိုရွေးပါ။');
    }
    return 'data:image/jpeg;base64,$encoded';
  }

  static ImageProvider? imageProvider(String? value) {
    if (value == null || value.isEmpty) return null;
    if (value.startsWith('data:image/')) {
      final separator = value.indexOf(',');
      if (separator < 0) return null;
      try {
        return MemoryImage(base64Decode(value.substring(separator + 1)));
      } on FormatException {
        return null;
      }
    }
    return NetworkImage(value);
  }
}
