import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _search;
  int _offset = 0;

  getGifs() async{ // função para chamar os gifs, caso seja uma pesquisa ou não

    http.Response response;
    if(_search == null){
      response = await http.get("https://api.giphy.com/v1/gifs/trending?api_key=xATYOrCizB00aq7uJdfcNLZsI1VphRAp&limit=25&rating=g");
    } else
      response = await http.get("https://api.giphy.com/v1/gifs/search?api_key=xATYOrCizB00aq7uJdfcNLZsI1VphRAp&q=$_search&limit=25&offset=$_offset&rating=g&lang=en");

    return json.decode(response.body);

  }


  @override
  /*void initState(){
    super.initState();

    getGifs().then((map){
      print(map);
    });
  }*/
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.network("https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      backgroundColor: Color(0xffA9A9A9),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              decoration: InputDecoration(
                  labelText: "Pesquisar",
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder()
              ),
            ),
          ),
          Expanded( // Criando e chamando o layout estrutural da aplicação
            child: FutureBuilder(
              future: getGifs(),
              builder: (context, snapshot){
                switch(snapshot.connectionState){
                  case ConnectionState.waiting: // caso a conexão esteja em aguardo
                  case ConnectionState.none: // caso a conexão esteja sem resposta
                    return Container( // criamos um progresso circular
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.0,
                      ),
                    );
                    default:
                  if(snapshot.hasError) return Container();
                  else return _createGifTable(context, snapshot);

                }
              },

            ),
          )

        ],

      ),

    );
  }

   Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot){
    
    return GridView.builder(
        padding: EdgeInsets.all(10.0) ,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0
        ),
        itemCount: 20,
        itemBuilder: (context, index){
          return GestureDetector(
            child: Image.network(snapshot.data["data"][index]["images"]["fixed_height"]["url"], height: 300.0, fit: BoxFit.cover,),

          );
        }
    );

  }



}
