import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/params/signup_params.dart';
import '../../../../core/provider/app_provider.dart';
import '../../../../core/routes/app_route_name.dart';
import '../../../../core/services/service_locater.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_btn.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../core/widgets/avatar.dart';
import '../../../features/auth/presentation/cubit/auth_bloc.dart';
import '../../../features/auth/presentation/cubit/auth_event.dart';
import '../../../features/auth/presentation/cubit/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _rePasswordController;
  late final TextEditingController _phoneController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isShowPassword = true;
  int selectedAvatarIndex = 0;

  final List<String> _avatars = [
    'assets/logo/profile1.png',
    'assets/logo/profile2.png',
    'assets/logo/profile3.png',
    'assets/logo/profile4.png',
    'assets/logo/profile5.png',
    'assets/logo/profile6.png',
    'assets/logo/profile7.png',
    'assets/logo/profile8.png',
    'assets/logo/profile9.png',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _rePasswordController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    _phoneController.dispose();
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
            Navigator.pushNamedAndRemoveUntil(
              context,
              RouteName.login,
              (route) => false,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Account Created! Please Login."),
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
            appBar: AppBar(title: Text(locale.register)),
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
                          AvatarPicker(
                            avatarList: _avatars,
                            avatarRadius: 70.w,
                            initialAvatar: _avatars[selectedAvatarIndex],
                            onAvatarChanged: (avatarPath) {
                              setState(() {
                                selectedAvatarIndex = _avatars.indexOf(avatarPath);
                              });
                            },
                          ),
                          SizedBox(height: 12.h,),
                          Text("Avatar",style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),),
                          const Spacer(),

                          TextFormField(
                            controller: _nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return "Please enter name";
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.person),
                              hintText: locale.name,
                            ),
                          ),
                          SizedBox(height: 12.h),

                          TextFormField(
                            controller: _emailController,
                            validator: (value) {
                              bool isEmail = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                              ).hasMatch(value ?? "");
                              if (value == null || value.isEmpty)
                                return "Please enter email";
                              if (!isEmail) return "Please enter valid email";
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.mail),
                              hintText: locale.email,
                            ),
                          ),
                          SizedBox(height: 12.h),

                          TextFormField(
                            controller: _passwordController,
                            obscureText: isShowPassword,
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return "Please enter password";
                              if (value.length < 6)
                                return "Must be at least 6 characters";
                              return null;
                            },
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

                          TextFormField(
                            controller: _rePasswordController,
                            obscureText: isShowPassword,
                            validator: (value) {
                              if (value != _passwordController.text)
                                return "Passwords do not match";
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock),
                              hintText: locale.rePassword,
                            ),
                          ),
                          SizedBox(height: 12.h),

                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return "Please enter phone number";
                              if (value.length != 11)
                                return "Phone number must be 11 digits";
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.phone),
                              hintText: locale.phoneNumber,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          const Spacer(),

                          CustomBtn(
                            isExpanded: true,
                            isLoading: state is AuthLoading,
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                  SignUpEvent(
                                    params: SignUpParams(
                                      name: _nameController.text.trim(),
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text,
                                      repassword: _rePasswordController.text,
                                      phone: _phoneController.text.trim(),
                                      avatarId: selectedAvatarIndex,
                                    ),
                                  ),
                                );
                              }
                            },
                            text: locale.createAccount,
                          ),
                          const Spacer(),

                          Text.rich(
                            TextSpan(
                              text: locale.haveAccount,
                              children: [
                                TextSpan(
                                  text: locale.login,
                                  style: theme.textTheme.bodyLarge!.copyWith(
                                    color: AppColors.secondaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    decorationColor: AppColors.secondaryColor,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushReplacementNamed(
                                        context,
                                        RouteName.login,
                                      );
                                    },
                                ),
                              ],
                            ),
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
