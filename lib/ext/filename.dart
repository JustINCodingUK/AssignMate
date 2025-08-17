import 'dart:io';

extension FileName on File {
  String get name => path.split("/").last;
}