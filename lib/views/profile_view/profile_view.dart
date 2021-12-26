import 'package:flutter/material.dart';

import '../../services/auth_service.dart';

class ProfileView extends StatelessWidget {
  ProfileView({Key? key}) : super(key: key);
  final auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(
          flex: 10,
        ),
        Expanded(
          flex: 6,
          child: buildAvatar(),
        ),
        Expanded(
          flex: 2,
          child: buildProfileInfo(),
        ),
        const Spacer(
          flex: 4,
        ),
        buildLogOutButton(context),
        const Spacer(flex: 10),
      ],
    );
  }

  CircleAvatar buildAvatar() {
    return const CircleAvatar(
      child: Icon(
        Icons.person,
        size: 40,
      ),
      radius: 40,
    );
  }

  Row buildProfileInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        auth.instance.currentUser!.email != null
            ? Text("${auth.instance.currentUser!.email}")
            : const Text("Guest"),
      ],
    );
  }

  Row buildLogOutButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () {
              auth.logOut();
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.power_settings_new_rounded,
              color: Colors.red,
            )),
        const Text("Log out"),
      ],
    );
  }
}
