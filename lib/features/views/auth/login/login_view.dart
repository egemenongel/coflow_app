import '../../../../core/components/buttons/custom_elevated_button.dart';

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
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(
              flex: 20,
            ),
            Expanded(
              flex: 16,
              child: buildForm(),
            ),
            Expanded(
              flex: 6,
              child: buildLoginButton(context),
            ),
            Expanded(
              flex: 3,
              child: buildDivider(),
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
        text: TextSpan(
            style: const TextStyle(
              color: Colors.black,
            ),
            children: [
          const TextSpan(text: "Don't have an account? "),
          TextSpan(
              text: "Register",
              style: const TextStyle(
                color: Colors.deepOrange,
              ),
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
        child: const Text(
          "Login as Guest",
          style: TextStyle(color: Colors.grey),
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
                    backgroundColor: Colors.white,
                    elevation: 0,
                    content: Consumer<FormController>(
                        builder: (_, _formController, __) {
                      return _formController.loginErrorText.isNotEmpty
                          ? Container(
                              color: Colors.red,
                              child: ListTile(
                                leading: const Icon(Icons.error),
                                title: Text(
                                  _formController.loginErrorText,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
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
          // child: ElevatedButton(
          //   child: const Text("Login"),
          //   onPressed: () async {
          //     if (_formKey.currentState!.validate()) {
          //       FocusScope.of(context).unfocus();
          //       var result = await auth.logIn(
          //         email: emailController.text,
          //         password: passwordController.text,
          //       );
          //       if (result is String) {
          //         context.read<FormController>().setLoginError(result);

          //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //           backgroundColor: Colors.white,
          //           elevation: 0,
          //           content: Consumer<FormController>(
          //               builder: (_, _formController, __) {
          //             return _formController.loginErrorText.isNotEmpty
          //                 ? Container(
          //                     color: Colors.red,
          //                     child: ListTile(
          //                       leading: const Icon(Icons.error),
          //                       title: Text(
          //                         _formController.loginErrorText,
          //                         style: const TextStyle(
          //                           color: Colors.white,
          //                         ),
          //                       ),
          //                     ),
          //                   )
          //                 : const SizedBox();
          //           }),
          //         ));
          //       } else {
          //         Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //               builder: (context) => const CustomPageView(),
          //             ));
          //       }
          //       _formKey.currentState!.reset();
          //     }
          //   },
          //   style: ElevatedButton.styleFrom(
          //       padding: const EdgeInsets.all(14),
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(15))),
          // ),
        ),
      ],
    );
  }

  Row buildDivider() {
    return Row(
      children: const [
        Expanded(
            child: Divider(
          color: Color(0xffFF7465),
          thickness: 2,
        )),
        Expanded(
            child: Center(
                child: Text(
          "OR",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ))),
        Expanded(
            child: Divider(
          color: Color(0xffFF7465),
          thickness: 2,
        )),
      ],
    );
  }

  Form buildForm() {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: "E-mail address",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
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
                          borderRadius: BorderRadius.circular(20)),
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
