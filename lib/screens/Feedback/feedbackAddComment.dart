import 'package:flutter/material.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final _text = TextEditingController();

  String usertext = "";
  String userscanner = "";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          iconTheme: IconThemeData(
            color: Color.fromARGB(
                255, 127, 127, 127), // Change the color of the icon here
          ),
          backgroundColor: Color.fromARGB(255, 243, 243, 243),
          centerTitle: true,
          title: Text(
            'myPoint',
            style: TextStyle(color: Color.fromARGB(255, 127, 127, 127)),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(right: 20, left: 20, top: 30),
          child: Column(
            children: [
              Text(
                'Write your comment:',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _text,
                maxLines: 6,
                minLines: 6,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 3, color: Colors.grey), //<-- SEE HERE
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _text.clear();
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.cancel, color: Colors.white),
                    label: Text('Cancel'),
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      await Future.delayed(Duration(milliseconds: 50));

                      Navigator.pop(context, "");
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(140, 40),
                      backgroundColor: Colors.grey[700],
                    ),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.send, color: Colors.white),
                    label: Text('OK'),
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      await Future.delayed(Duration(milliseconds: 50));
                      Navigator.pop(context, _text.text);
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(140, 40),
                      backgroundColor: Colors.green[700],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
