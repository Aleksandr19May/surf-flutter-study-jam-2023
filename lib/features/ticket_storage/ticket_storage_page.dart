import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:surf_flutter_study_jam_2023/features/model.dart';

bool right = true;

/// Экран “Хранения билетов”.
class TicketStoragePage extends StatefulWidget {
  TicketStoragePage({Key? key}) : super(key: key);

  @override
  State<TicketStoragePage> createState() => _TicketStoragePageState();
}

class _TicketStoragePageState extends State<TicketStoragePage> {
  late Box<NewFile> saver;
  @override
  void initState() {
    super.initState();
    saver = Hive.box<NewFile>('PDF');
  }

  void deleteAll() async {
    saver = Hive.box<NewFile>('PDF');
    await saver.clear();
    setState(() {});
  }

  var controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    List listSaved = saver.values.toList();

    String? _errorText = null;

    void _check() {
      final login = controller.text;

      if (RegExp(r'http.*pdf|https.*pdf').hasMatch(login)) {
        _errorText = null;
        saver.add(
            NewFile(newUrl: controller.text, fileName: '', isdownload: false));

        //  Navigator.of(context).pushNamed('/mainScreen');
        Navigator.of(context).pop();
        controller.text = '';
        setState(() {});
         ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.green,
      content: Text('Ссылка на файл успешно добавлена!'),
      duration: Duration(seconds: 2),
    ),
  );
      } else {
        _errorText = 'Введите корректный Url';
        setState(() {});
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        title: const Text(
          'Хранение билетов',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      body: listSaved.isEmpty
          ? const Center(
              child: Text(
                'Здесь пока ничего нет',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              itemCount: listSaved.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: ListTile(
                    leading: const Icon(Icons.train),
                    trailing: IconButton(
                      onPressed: () {downloadPdf('https://journal-free.ru/download/dachnye-sekrety-11-noiabr-2019.pdf');},
                      icon: Icon(Icons.cloud_download_rounded) ,
                      color: Colors.purple,
                    ),
                    title: Text(
                      'Ticket ${index + 1}',
                      style: TextStyle(color: Colors.purple.shade400),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
                onPressed: deleteAll, child: const Text('удалить все')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {
                showModalBottomSheet<void>(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: SizedBox(
                          height: 200,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: TextField(
                                    keyboardType: TextInputType.text,
                                    controller: controller,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(fontSize: 20),
                                    decoration: InputDecoration(
                                        errorText: _errorText,
                                        hintText: "Введите Url",
                                        labelText: "Введите Url",
                                        hintStyle: const TextStyle(
                                            fontWeight: FontWeight.normal),
                                        border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 20)),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        Colors.brown.shade400),
                                  ),
                                  child: const Text('Добавить',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15)),
                                  onPressed: _check,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              child: Text(
                'Добавить',
                style: TextStyle(
                    color: Colors.blue.shade900,
                    fontSize: 17,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


Future<void> downloadPdf(String url) async {
  Dio dio = Dio();

  try {
    // Определение директории, где будет сохранен файл PDF
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/file.pdf';

    // Загрузка файла PDF с сервера
    await dio.download(url, filePath);

    print('PDF загружен: $filePath');
  } catch (e) {
    print('Ошибка загрузки PDF: $e');
  }
}





