import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movies/modules/auth/manager/auth_provider.dart';
import 'package:provider/provider.dart';
import '../../../core/provider/app_provider.dart';
import '../../../core/routes/app_route_name.dart';
import '../../../core/widgets/custom_btn.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  bool isShowPassword = true;
  @override
  Widget build(BuildContext context) {
    var appProvider = Provider.of<AppProvider>(context);
    var theme = Theme.of(context);
    var locale = AppLocalizations.of(context)!;
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: Scaffold(
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
                        children: [
                          Spacer(),
                          Center(
                            child: Hero(
                              tag: "logo",
                              child: Image.asset("assets/logo/app_logo.png"),
                            ),
                          ),
                          Spacer(),
                          TextFormField(
                            controller: provider.emailController,
                            validator: (value) {
                              bool isEmail = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                              ).hasMatch(value!);
                              if (value == null || value.isEmpty) {
                                return "Please enter email";
                              } else if (!isEmail) {
                                return "Please enter valid email";
                              } else {
                                return null;
                              }
                            },
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.mail),
                              hintText: locale.email,
                            ),
                          ),
                          SizedBox(height: 12),
                          StatefulBuilder(
                            builder: (context, setState) {
                              return TextFormField(
                                controller: provider.passwordController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter password";
                                  } else if (value.length < 6) {
                                    return "must be length more than 6 numbers";
                                  } else {
                                    return null;
                                  }
                                },
                                onTapOutside: (event) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                                obscureText: isShowPassword,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.lock),
                                  hintText: locale.password,
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      isShowPassword = !isShowPassword;
                                      setState(() {});
                                    },
                                    child: Icon(
                                      isShowPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    RouteName.forgetPassword,
                                  );
                                },
                                child: Text(
                                  locale.forgetPassword,
                                  style: theme.textTheme.bodyLarge!.copyWith(
                                    color: AppColors.secondaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.secondaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          CustomBtn(
                            isLoading: provider.isLoading,
                            isExpanded: true,
                            onTap: () async{
                              bool success = await provider.login(context);
                              if(success){
                                Navigator.pushReplacementNamed(context, RouteName.layout);
                              }
                            },
                            text: locale.login,
                          ),
                          Spacer(),
                          Text.rich(
                            TextSpan(
                              text: locale.notHaveAccount,
                              children: [
                                TextSpan(
                                  text: locale.createOne,
                                  style: theme.textTheme.bodyLarge!.copyWith(
                                    color: AppColors.secondaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    decorationColor: AppColors.secondaryColor,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushNamed(
                                        context,
                                        RouteName.register,
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 100,
                                child: Divider(
                                  color: AppColors.secondaryColor,
                                  thickness: 1,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                locale.or,
                                style: TextStyle(
                                  color: AppColors.secondaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              SizedBox(
                                width: 100,
                                child: Divider(
                                  color: AppColors.secondaryColor,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          CustomBtn(
                            isLoading: provider.isLoading,
                            isExpanded: true,
                            onTap: () async {
                              bool success = await provider.signInWithGoogle(context);
                              if(success && context.mounted){
                                Navigator.pushReplacementNamed(context, RouteName.layout);
                              }
                            },
                            text: locale.googleLogin,
                            icon: FontAwesomeIcons.google,
                          ),
                          Spacer(),
                          AnimatedToggleSwitch<String>.rolling(
                            current: appProvider.local,
                            values: ["en", "ar"],
                            iconList: [
                              Image.asset("assets/icons/en.png"),
                              Image.asset("assets/icons/ar.png"),
                            ],
                            onChanged: (value) {
                              appProvider.changeLanguage(value);
                            },
                            indicatorIconScale: 1.2,
                            style: ToggleStyle(
                              backgroundColor: Colors.transparent,
                              indicatorColor: AppColors.secondaryColor,
                              borderColor: AppColors.secondaryColor,
                            ),
                            textDirection: TextDirection.ltr,
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
