import 'package:flutter/material.dart';
import 'Widget.dart';

void main(){
  runApp(MaterialApp(
      home: DropdownTextFieldPage(),
      title: 'Widget Test',
      debugShowCheckedModeBanner: false,
    )
  );
}


class DropdownTextFieldPage extends StatefulWidget {
  @override
  _DropdownTextFieldPageState createState() => _DropdownTextFieldPageState();
}

class _DropdownTextFieldPageState extends State<DropdownTextFieldPage> {

  bool label = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              DropdownText(
                options: <String>[
                  "Teste",
                  "Paçoca",
                  "Agora não",
                  "Testando",
                  "Agora sim",
                  "Acho que foi"
                ],
                caseSensitive: false,
                border: BorderStyle.solid,
                padding: EdgeInsets.all(10.0),
                label: true,
                labelText: Text("Teste:"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}