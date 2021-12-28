import '../../../../core/components/buttons/custom_elevated_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coflow_app/core/extension/context_extension.dart';
import '../../../controllers/auth_toggle.dart';
import '../../../controllers/form_controller.dart';
import '../../../services/auth_service.dart';

class SignUpView extends StatelessWidget {
  SignUpView({Key? key}) : super(key: key);
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
              child: buildSignUpButton(context),
            ),
            const Spacer(
              flex: 4,
            ),
            Expanded(
              flex: 4,
              child: buildLoginText(context),
            ),
            const Spacer(
              flex: 13,
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  RichText buildLoginText(BuildContext context) {
    return RichText(
        text: TextSpan(children: [
      const TextSpan(text: "Have an account? "),
      TextSpan(
          text: "Login",
          style: context.textTheme.bodyText2!
              .copyWith(color: context.colors.primary),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              context.read<AuthToggle>().toggle();
            }),
    ], style: context.textTheme.bodyText2));
  }

  Row buildSignUpButton(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                FocusScope.of(context).unfocus();
                var result = await auth.signUp(
                  email: emailController.text,
                  password: passwordController.text,
                );
                if (result is String) {
                  context.read<FormController>().setSigUpError(result);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: context.colors.background,
                    elevation: 0,
                    content: Consumer<FormController>(
                        builder: (_, _formController, __) {
                      return _formController.signUpErrorText.isNotEmpty
                          ? Container(
                              color: context.colors.error,
                              child: ListTile(
                                leading: const Icon(Icons.error),
                                title: Text(_formController.signUpErrorText,
                                    style: context.textTheme.bodyText1!
                                        .copyWith(
                                            color: context.colors.onSecondary)),
                              ),
                            )
                          : const SizedBox();
                    }),
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("You succesfully signed up. Now Login.")));
                }
                _formKey.currentState!.reset();
              }
            },
            text: "Sign Up",
          ),
        ),
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
