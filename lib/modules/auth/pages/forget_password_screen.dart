import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/custom_btn.dart';
import '../../../l10n/app_localizations.dart';
import '../manager/auth_provider.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  Future<void> passwordReset(BuildContext context, AuthProvider provider) async {
    final email = provider.emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your email")),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("If this email is registered, a password reset link has been sent.")),
      );
    } on FirebaseAuthException catch (e) {
      String message = "Something went wrong";

      switch (e.code) {
        case "invalid-email":
          message = "Invalid email address";
          break;
        case "user-not-found":

          message = "If this email is registered, a password reset link has been sent.";
          break;
        default:
          message = e.message ?? "Something went wrong";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;

    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(locale.resetPassword),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<AuthProvider>(
              builder: (context, provider, child) {
                return Form(
                  key: provider.formKey,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Center(
                            child: Image.asset("assets/images/reset_password.png"),
                          ),
                          TextFormField(
                            controller: provider.emailController,
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.mail),
                              hintText: locale.email,
                            ),
                          ),
                          const SizedBox(height: 28),
                          CustomBtn(
                            isExpanded: true,
                            onTap: () => passwordReset(context, provider),
                            text: locale.verifyEmail,
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
