import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../../core/extension/context_extension.dart';

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
          child: buildAvatar(context),
        ),
        Expanded(
          flex: 2,
          child: buildProfileInfo(context),
        ),
        const Spacer(
          flex: 4,
        ),
        buildLogOutButton(context),
        const Spacer(flex: 10),
      ],
    );
  }

  CircleAvatar buildAvatar(BuildContext context) {
    return CircleAvatar(
      backgroundColor: context.colors.secondary,
      child: Icon(
        Icons.person,
        color: context.theme.iconTheme.color,
        size: 50,
      ),
      radius: 50,
    );
  }

  Row buildProfileInfo(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        auth.instance.currentUser!.email != null
            ? Text(
                "${auth.instance.currentUser!.email}",
                style: context.textTheme.bodyText1,
              )
            : Text(
                "Guest",
                style: context.textTheme.bodyText1,
              ),
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
            icon: Icon(
              Icons.power_settings_new_rounded,
              color: context.colors.error,
            )),
        Text(
          "Log out",
          style: context.textTheme.bodyText2,
        ),
      ],
    );
  }
}
