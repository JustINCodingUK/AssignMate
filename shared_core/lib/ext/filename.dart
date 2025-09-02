import 'dart:io';

extension FileName on File {
  String get name {
    try {
      return Uri.decodeFull(path).split("/").last;
    } catch(e) {
      return path.split("/").last;
    }
  }
}