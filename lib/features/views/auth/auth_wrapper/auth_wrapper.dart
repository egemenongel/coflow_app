import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/auth_toggle.dart';
import '../login/login_view.dart';
import '../sign_up.dart/sign_up_view.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthToggle>(
      builder: (_, _toggle, __) => _toggle.isLogin ? LoginView() : SignUpView(),
    );
  }
}
