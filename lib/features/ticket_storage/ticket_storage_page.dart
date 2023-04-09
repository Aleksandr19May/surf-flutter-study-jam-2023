import 'dart:async';
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

  void deleteAll() async {
    // Стираем данные из Hive
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
      // Валидация и добавление новой записи
      final login = controller.text;

      if (RegExp(r'http.*pdf|https.*pdf').hasMatch(login)) {
        _errorText = null;
        saver.add(NewFile(
            newUrl: controller.text,
            fileName: '',
            isdownload: false,
            downloadStatus: DownloadStatus.notStarted.toString()));
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

    // double _progressValue =0.0;
    // StreamController<double> _progressStreamController ;

    Future<void> downloadPdf(String url, int index) async {
      Dio dio = Dio();

      try {
        // Определение директории, где будет сохранен файл PDF
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/file.pdf';
        setState(() {
          listSaved[index].changeStatus(DownloadStatus.inProgress);
        });
        // Загрузка файла PDF с сервера
        await dio.download(url, filePath, onReceiveProgress: (received, total) {
          if (total != -1) {
            //  final progress = received / total;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Файл загружен!'),
            duration: Duration(seconds: 2),
          ),
        );
        setState(() {
          listSaved[index].changeStatus(DownloadStatus.finished);
        });
      } catch (e) {
        setState(() {
          listSaved[index].changeStatus(DownloadStatus.finished);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Не удалось загрузить файл $e'),
            duration: const Duration(seconds: 2),
          ),
        );
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
                    isThreeLine: true,
                    leading: const Icon(Icons.train),
                    trailing: IconButton(
                      onPressed: () {
                        downloadPdf(listSaved[index].newUrl, index);
                      },
                      icon: Icon(
                        listSaved[index].downloadStatus ==
                                DownloadStatus.finished.toString()
                            ? Icons.check_circle
                            : listSaved[index].downloadStatus ==
                                    DownloadStatus.inProgress.toString()
                                ? Icons.pause_circle
                                : Icons.cloud_download_rounded,
                        size: 30,
                      ),
                      color: Colors.purple,
                    ),
                    subtitle: const LinearProgressIndicator(
                      backgroundColor: Colors.red,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                    ),
                    title: Row(
                      children: [
                        Text(
                          'Ticket ${index + 1} ',
                          style: TextStyle(color: Colors.purple.shade400),
                        ),
                        IconButton(
                            onPressed: () {
                              // PDFScreen(
                              //   filePath: listSaved[index].newUrl,
                              // );
                            },
                            icon: const Icon(Icons.remove_red_eye_sharp)),
                      ],
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
            Padding(
              padding: const EdgeInsets.only(right: 220.0),
              child: IconButton(
                  onPressed: deleteAll,
                  icon: const Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                    size: 30,
                  )),
            ),
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
                                  onPressed: _check,
                                  child: const Text('Добавить',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15)),
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
