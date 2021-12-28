import '../../../../core/components/buttons/custom_elevated_button.dart';
import '../../../../core/extension/context_extension.dart';

import '../../page_view/page_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/auth_toggle.dart';
import '../../../controllers/form_controller.dart';
import '../../../services/auth_service.dart';

class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: context.paddingMedium,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(
              flex: 20,
            ),
            Expanded(
              flex: 16,
              child: buildForm(context),
            ),
            Expanded(
              flex: 6,
              child: buildLoginButton(context),
            ),
            Expanded(
              flex: 3,
              child: buildDivider(context),
            ),
            Expanded(
              flex: 4,
              child: buildLoginAsGuestButton(context),
            ),
            const Spacer(
              flex: 2,
            ),
            Expanded(
              flex: 4,
              child: buildRegisterText(context),
            ),
            const Spacer(
              flex: 8,
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  RichText buildRegisterText(BuildContext context) {
    return RichText(
        text: TextSpan(style: context.textTheme.bodyText2, children: [
      const TextSpan(text: "Don't have an account? "),
      TextSpan(
          text: "Register",
          style: context.textTheme.bodyText2!
              .copyWith(color: context.colors.primary),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              context.read<AuthToggle>().toggle();
            }),
    ]));
  }

  TextButton buildLoginAsGuestButton(BuildContext context) {
    return TextButton(
        onPressed: () {
          auth.loginAnonymously();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CustomPageView()));
        },
        child: Text(
          "Login as Guest",
          style: TextStyle(color: context.colors.onBackground),
        ));
  }

  Row buildLoginButton(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomElevatedButton(
            text: "Login",
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                FocusScope.of(context).unfocus();
                var result = await auth.logIn(
                  email: emailController.text,
                  password: passwordController.text,
                );
                if (result is String) {
                  context.read<FormController>().setLoginError(result);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: context.colors.background,
                    elevation: 0,
                    content: Consumer<FormController>(
                        builder: (_, _formController, __) {
                      return _formController.loginErrorText.isNotEmpty
                          ? Container(
                              color: context.colors.error,
                              child: ListTile(
                                leading: const Icon(Icons.error),
                                title: Text(_formController.loginErrorText,
                                    style: context.textTheme.bodyText1!
                                        .copyWith(
                                            color: context.colors.onSecondary)),
                              ),
                            )
                          : const SizedBox();
                    }),
                  ));
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CustomPageView(),
                      ));
                }
                _formKey.currentState!.reset();
              }
            },
          ),
        ),
      ],
    );
  }

  Row buildDivider(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Divider(
          thickness: 2,
          color: context.colors.primary,
        )),
        Expanded(
            child:
                Center(child: Text("OR", style: context.textTheme.bodyText1!))),
        Expanded(
            child: Divider(
          thickness: 2,
          color: context.colors.primary,
        )),
      ],
    );
  }

  Form buildForm(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: "E-mail address",
                    border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(context.mediumValue))),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                validator: (value) =>
                    value!.isEmpty ? "Please enter your e-mail" : null,
              ),
            ),
            Expanded(
              child:
                  Consumer<FormController>(builder: (_, _formController, __) {
                return TextFormField(
                  decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(context.mediumValue)),
                      suffixIcon: IconButton(
                          onPressed: _formController.showPassword,
                          icon: Icon(_formController.isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility))),
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _formController.isPasswordVisible,
                  controller: passwordController,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter your password" : null,
                );
              }),
            )
          ],
        ));
  }
}
