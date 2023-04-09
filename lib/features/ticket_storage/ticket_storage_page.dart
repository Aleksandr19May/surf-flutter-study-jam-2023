import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
bool right = true;
/// Экран “Хранения билетов”.
class TicketStoragePage extends StatelessWidget {
  const TicketStoragePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        title: const Text(
          'Хранение билетов',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return const ListTile(
            leading: Icon(Icons.train),
            trailing: Icon(
              Icons.cloud_download_rounded,
              color: Colors.purple,
            ),
            title: Text('df'),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
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
                    return Padding(
                      padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: SizedBox(
                        height: 200,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20.0),
                                child: TextField(
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(fontSize: 20),
                                  decoration: InputDecoration(
                                   errorText: !right ?'Введите корректный Url': '' ,
                                      hintText: "Введите Url",
                                      helperText: 'Введите Url',
                                      labelText:'Введите Url' ,
                                     
                                      hintStyle: const TextStyle(
                                          fontWeight: FontWeight.normal),
                                      border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      contentPadding:
                                          const EdgeInsets.symmetric(horizontal: 20)),
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
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
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








// class DownloadPdfScreen extends StatefulWidget {
//   final String pdfUrl;

//   DownloadPdfScreen( this.pdfUrl);

//   @override
//   _DownloadPdfScreenState createState() => _DownloadPdfScreenState();
// }

// class _DownloadPdfScreenState extends State<DownloadPdfScreen> {
//   bool _isLoading = false;

//   Future<void> _downloadPdf() async {
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       final response = await http.get(Uri.parse(widget.pdfUrl));
//       final bytes = response.bodyBytes;
//       final appDir = await getApplicationDocumentsDirectory();
//       final file = File('${appDir.path}/file.pdf');
//       await file.writeAsBytes(bytes);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Файл успешно загружен'),
//         ),
//       );
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Ошибка при загрузке файла'),
//         ),
//       );
//     }
//     setState(() {
//       _isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Загрузить PDF'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: _isLoading ? null : _downloadPdf,
//           child: _isLoading
//               ? CircularProgressIndicator()
//               : Text('Загрузить PDF'),
//         ),
//       ),
//     );
//   }
// }
