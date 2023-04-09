import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:path_provider/path_provider.dart';
import 'package:surf_flutter_study_jam_2023/features/model.dart';

bool right = true;

/// Экран “Хранения билетов”.
class TicketStoragePage extends StatefulWidget {
  const TicketStoragePage({Key? key}) : super(key: key);

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

  void deleteAll() async { // Стираем данные из Hive
    saver = Hive.box<NewFile>('PDF');
    await saver.clear();
    setState(() {});
  }

  var controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    List<NewFile> listSaved = saver.values.toList();

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
          const SnackBar(
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

    bool _downloading = false;
    double _progressValue = 0.0;

    Future<void> downloadPdf(String url) async {
      Dio dio = Dio();

      try {
        // Определение директории, где будет сохранен файл PDF
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/file.pdf';
        setState(() {
          _downloading = true;
        });
        // Загрузка файла PDF с сервера
        await dio.download(url, filePath, onReceiveProgress: (received, total) {
          if (total != -1) {
            print(
                'Received: ${received ~/ 1024 / 1000}МB / Total: ${total ~/ 1024 / 1000}МB');
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Файл загружен!'),
            duration: Duration(seconds: 2),
          ),
        );
        // print('PDF загружен: $filePath');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Не удалось загрузить файл $e'),
            duration: const Duration(seconds: 2),
          ),
        );
        // print('Ошибка загрузки PDF: $e');
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
                    isThreeLine: true ,
                    leading: const Icon(Icons.train),
                    trailing: IconButton(
                      onPressed: () {
                        downloadPdf(listSaved[index].newUrl);
                      },
                      icon: const Icon(Icons.cloud_download_rounded),
                      color: Colors.purple,
                    ),
                    subtitle:  Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
     
      Text('Ожидает начало загрузки'),
      
      if (_downloading)
        LinearProgressIndicator(
          value: _progressValue,
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
        ),
    ],
  ),
                    title: Text(
                      'Ticket ${index + 1} ' ,
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
