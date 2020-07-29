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
    if(_search == null || _search.isEmpty){
      response = await http.get("https://api.giphy.com/v1/gifs/trending?api_key=xATYOrCizB00aq7uJdfcNLZsI1VphRAp&limit=29&rating=g");
    } else
      response = await http.get("https://api.giphy.com/v1/gifs/search?api_key=xATYOrCizB00aq7uJdfcNLZsI1VphRAp&q=$_search&limit=29&offset=$_offset&rating=g&lang=en");

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
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Pesquisar",
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder()
              ),
              onSubmitted: (text){
                setState(() {

                  _search = text; // colocando o texto na variável search
                  _offset = 0;

                });
              },
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

  int _getCount(List data){

    if(getGifs()==null){ //caso a não haja busca, seja igual a nulo
      return data.length; // retornar apenas o tamanho real da serie de gifs(tamanho dos dados), não tem espaço no final
    } else {
      return
         data.length +1; // caso esteja retorna com + 1 espaço

    }


  }

   Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot){
    
    return GridView.builder(
        padding: EdgeInsets.all(10.0) ,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0
        ),
        itemCount: _getCount(snapshot.data["data"]),
        itemBuilder: (context, index){
          if( _search == null || index < snapshot.data["data"].length)
          return GestureDetector(
            child: Image.network(snapshot.data["data"][index]["images"]["fixed_height"]["url"], height: 300.0, fit: BoxFit.cover,),
          );
          else
            return
                Container(
                  child: GestureDetector(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.add, color: Colors.white, size: 70.0,),
                        Text("Carregar mais",
                        style: TextStyle(color: Colors.white, fontSize: 22.0),
                        )
                      ],
                    ),
                    onTap: (){
                      setState(() {
                        _offset +=19;

                      });
                    },
                  ),
                );
        }
    );

  }



}
