
import 'package:hive_flutter/hive_flutter.dart';
import 'package:surf_flutter_study_jam_2023/features/model.dart';

import 'model.dart';


class NewFile {
  String fileName = '';
  bool isdownload = false;  
   final String newUrl;
NewFile({ required this.newUrl, required this.fileName,required this.isdownload});

}


class HiveNewFile extends TypeAdapter <NewFile> {
@override
  final typeId = 1;


  @override
  NewFile read(BinaryReader reader) {
    String fileName = reader.readString();
  bool isdownload = reader.readBool();  
   final String newUrl = reader.readString();
   return NewFile(newUrl: newUrl, fileName: fileName, isdownload: isdownload);
  }



  @override
  void write(BinaryWriter writer, NewFile obj) {
   writer.writeString(obj.fileName);
   writer.writeBool(obj.isdownload);
   writer.writeString(obj.newUrl);
  }


}