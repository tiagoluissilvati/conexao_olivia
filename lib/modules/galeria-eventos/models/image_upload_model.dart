class ImageUpload {
  final String localPath;
  final String fileName;
  final String mimeType;
  final int fileSize;

  ImageUpload({
    required this.localPath,
    required this.fileName,
    required this.mimeType,
    required this.fileSize,
  });
}