import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:quiz/pages/char_detail.dart';
import 'package:quiz/connection/base.dart';
import 'package:quiz/components/list_card.dart';

class CharacterPage extends StatefulWidget {
  @override
  _CharacterPageState createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {

  Future<List<String>>? _characterNames;
  final BaseNetwork _client = BaseNetwork();

  @override
  void initState() {
    super.initState();
    try {
      _characterNames = _client.fetchMainCharacters();
    } on Exception catch (e) {
      print('Error fetching weapons: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Genshin Characters",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
        ),
      ),
      body: Center(
        child: FutureBuilder<List<String>>(
          future: _characterNames,
          builder: (context, snapshot){
            if(snapshot.hasData){
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final character = snapshot.data![index];
                  return GestureDetector(
                    child: ListCard(context: context, title: character),
                    onTap: (){
                      print("name: $character");
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => CharacterDetailPage(charName: character),
                        ),
                      );
                    },
                  );
                  //return Text(weapon);
                },
              );
            }else if(snapshot.hasError){

            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
