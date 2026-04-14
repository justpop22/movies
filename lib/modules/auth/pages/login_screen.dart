import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../core/params/login_params.dart';
import '../../../../core/provider/app_provider.dart';
import '../../../../core/routes/app_route_name.dart';
import '../../../../core/services/service_locater.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_btn.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../features/auth/presentation/cubit/auth_bloc.dart';
import '../../../features/auth/presentation/cubit/auth_event.dart';
import '../../../features/auth/presentation/cubit/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isShowPassword = true;
  String? _activeAction;


  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appProvider = Provider.of<AppProvider>(context);
    var theme = Theme.of(context);
    var locale = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            setState(() {
              _activeAction = null;
            });
            Navigator.pushReplacementNamed(context, RouteName.layout);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Welcome back, ${state.user.displayName}"),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.all(20.0).w,
                child: Form(
                  key: _formKey,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          const Spacer(),
                          Center(
                            child: Hero(
                              tag: "logo",
                              child: Image.asset("assets/logo/app_logo.png"),
                            ),
                          ),
                          const Spacer(),

                          TextFormField(
                            controller: _emailController,
                            validator: (value) {
                              bool isEmail = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                              ).hasMatch(value ?? "");
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
                              prefixIcon: const Icon(Icons.mail),
                              hintText: locale.email,
                            ),
                          ),
                          SizedBox(height: 12.h),

                          TextFormField(
                            controller: _passwordController,
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
                              prefixIcon: const Icon(Icons.lock),
                              hintText: locale.password,
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    isShowPassword = !isShowPassword;
                                  });
                                },
                                child: Icon(
                                  isShowPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),

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
                          const Spacer(),

                          CustomBtn(
                            isLoading: state is AuthLoading && _activeAction == 'email',
                            isExpanded: true,
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _activeAction = 'email';
                                });
                                context.read<AuthBloc>().add(
                                  LoginEvent(
                                    params: LoginParams(
                                      emailOrUsername: _emailController.text
                                          .trim(),
                                      password: _passwordController.text,
                                    ),
                                  ),
                                );
                              }
                            },
                            text: locale.login,
                          ),
                          const Spacer(),
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
                          const Spacer(),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 100.w,
                                child: Divider(
                                  color: AppColors.secondaryColor,
                                  thickness: 1,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                locale.or,
                                style: const TextStyle(
                                  color: AppColors.secondaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              SizedBox(
                                width: 100.w,
                                child: Divider(
                                  color: AppColors.secondaryColor,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),

                          CustomBtn(
                            isLoading: state is AuthLoading && _activeAction == 'google',
                            isExpanded: true,
                            onTap: () {
                              setState(() {
                                _activeAction = 'google';
                              });
                              context.read<AuthBloc>().add(
                                LoginWithGoogleEvent(),
                              );
                            },
                            text: locale.googleLogin,
                            icon: FontAwesomeIcons.google,
                          ),
                          const Spacer(),

                          AnimatedToggleSwitch<String>.rolling(
                            current: appProvider.local,
                            values: const ["en", "ar"],
                            iconList: [
                              Image.asset("assets/icons/en.png"),
                              Image.asset("assets/icons/ar.png"),
                            ],
                            onChanged: (value) {
                              appProvider.changeLanguage(value);
                            },
                            indicatorIconScale: 1.2,
                            style: const ToggleStyle(
                              backgroundColor: Colors.transparent,
                              indicatorColor: AppColors.secondaryColor,
                              borderColor: AppColors.secondaryColor,
                            ),
                            textDirection: TextDirection.ltr,
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
