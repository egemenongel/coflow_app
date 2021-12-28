import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../../core/extension/context_extension.dart';

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
                return buildCharacterCard(context, character);
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

  Column buildCharacterCard(BuildContext context, character) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(context.lowValue),
          child: Image.network(
            "${character.img}",
          ),
        ),
        ListTile(
          contentPadding: context.paddingLow,
          title: Center(
              child: Text(
            "${character.name}",
            style: context.textTheme.headline5,
          )),
          subtitle: Center(
            child: RichText(
                text: TextSpan(
                    style: context.textTheme.bodyText1!
                        .copyWith(color: context.colors.primary),
                    children: [
                  const TextSpan(text: "Birthday:  "),
                  TextSpan(
                    text: "${character.birthday}",
                    style: context.textTheme.bodyText2,
                  ),
                ])),
          ),
        ),
      ],
    );
  }
}
