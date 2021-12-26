import 'package:flutter/material.dart';

import '../../services/api_service.dart';

class CharactersView extends StatefulWidget {
  const CharactersView({Key? key}) : super(key: key);

  @override
  State<CharactersView> createState() => _CharactersViewState();
}

class _CharactersViewState extends State<CharactersView> {
  final apiService = ApiService();
  late Future charactersList;
  @override
  void initState() {
    super.initState();
    charactersList = apiService.getCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: charactersList,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                var character = snapshot.data[index];
                return buildCharacterCard(character);
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Column buildCharacterCard(character) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            "${character.img}",
          ),
        ),
        ListTile(
          title: Center(child: Text("${character.name}")),
          subtitle: Center(child: Text("Birthday: ${character.birthday}")),
        ),
      ],
    );
  }
}
