import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance"; //string de API

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.white),
  )); //Classe Main
}

//Futuro acontece apenas no futuro não no momento
Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //Criação do scarfollding

  double dolar;
  double euro;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("Convesor de Moedas"),
          backgroundColor: Colors.amber,
          centerTitle: true,
        ),
        body: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                      //Inicialização do projeto
                      child: Text(
                    "Carregando dados",
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ));
                default:
                  if (snapshot.hasError) {
                    //Se o servidor cair não carrega
                    return Center(
                        child: Text(
                      "Erro ao carregar os dados, verifique a sua conexão",
                      style: TextStyle(color: Colors.amber, fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ));
                  } else {
                    dolar =
                        snapshot.data["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                    return SingleChildScrollView(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(
                            Icons.monetization_on,
                            size: 150,
                            color: Colors.amber,
                          ),
                          TextField(
                              decoration: InputDecoration(
                                  labelText: "Reais",
                                  labelStyle: TextStyle(color: Colors.amber),
                                  border: OutlineInputBorder(),
                                  prefixText: "R\$"),
                              style:
                                  TextStyle(color: Colors.amber, fontSize: 25)),
                          Divider(),
                          TextField(
                              decoration: InputDecoration(
                                  labelText: "Dólar",
                                  labelStyle: TextStyle(color: Colors.amber),
                                  border: OutlineInputBorder(),
                                  prefixText: "US\$"),
                              style:
                                  TextStyle(color: Colors.amber, fontSize: 25)),
                          Divider(),
                          TextField(
                              decoration: InputDecoration(
                                  labelText: "Reais",
                                  labelStyle: TextStyle(color: Colors.amber),
                                  border: OutlineInputBorder(),
                                  prefixText: "£"),
                              style:
                                  TextStyle(color: Colors.amber, fontSize: 25))
                        ],
                      ),
                    );
                  }
              }
            }));
  }
}
