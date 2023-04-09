import 'package:hive_flutter/hive_flutter.dart';

enum DownloadStatus {
  notStarted,
  inProgress,
  finished,
}

class NewFile {
  String fileName = '';
  bool isdownload = false;
  final String newUrl;
  String downloadStatus;
  NewFile(
      {required this.downloadStatus,
      required this.newUrl,
      required this.fileName,
      required this.isdownload});

  void changeStatus(DownloadStatus status) {
    downloadStatus = status.toString();
  }
}
 // Адаптер для работы HIVE
class HiveNewFile extends TypeAdapter<NewFile> {
  @override
  final typeId = 2;

  @override
  NewFile read(BinaryReader reader) {
    String fileName = reader.readString();
    bool isdownload = reader.readBool();
    final String newUrl = reader.readString();
    String downloadStatus = reader.readString();
    return NewFile(
        newUrl: newUrl,
        fileName: fileName,
        isdownload: isdownload,
        downloadStatus: downloadStatus);
  }

  @override
  void write(BinaryWriter writer, NewFile obj) {
    writer.writeString(obj.fileName);
    writer.writeBool(obj.isdownload);
    writer.writeString(obj.newUrl);
    writer.writeString(obj.downloadStatus);
  }
}
