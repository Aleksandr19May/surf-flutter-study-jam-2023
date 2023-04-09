import 'package:flutter/material.dart';

/// Экран “Хранения билетов”.
class TicketStoragePage extends StatelessWidget {
  const TicketStoragePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        title: Text(
          'Хранение билетов',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder:(BuildContext context, int index) {
          return ListTile(
            leading: Icon(Icons.train),
            trailing: Icon(Icons.cloud_download_rounded,color: Colors.purple,),
            title: Text('df'),
          );
        },
    ),
  bottomNavigationBar: Padding(
    padding: const EdgeInsets.all(15.0),
    child: Row(mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade100,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15), 
    ),
  ), 
  
          onPressed: (){

 showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return SizedBox(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text('Modal BottomSheet'),
                      ElevatedButton(
                        child: const Text('Close BottomSheet'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              );
            },
          );





          }, child: Text('Добавить', style: TextStyle(color: Colors.blue.shade900,fontSize: 17,fontWeight: FontWeight.w600),),),
      ],
    ),
  ),
    
    );
    
  }
}
