import 'dart:io';

void generateDataFile({
  required int size,
  required String fileName,
}) {
  final file = File(fileName);

  const String englishChars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ';
  final int targetSize = size * 1024; // Size KB

  final StringBuffer buffer = StringBuffer();
  while (buffer.length < targetSize) {
    buffer.write(englishChars);
  }

  String fileContent = buffer.toString().substring(0, targetSize);
  file.writeAsStringSync(fileContent);

  print('File generated: $fileName');
}
