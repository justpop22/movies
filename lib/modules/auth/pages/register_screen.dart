import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:movies/modules/auth/services/auth_services.dart';
import 'package:provider/provider.dart';
import '../../../core/provider/app_provider.dart';
import '../../../core/routes/app_route_name.dart';
import '../../../core/widgets/avatar.dart';
import '../../../core/widgets/custom_btn.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../manager/auth_provider.dart';
class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  bool isShowPassword = true;
  @override
  Widget build(BuildContext context) {
    var appProvider = Provider.of<AppProvider>(context);
    var theme = Theme.of(context);
    var locale = AppLocalizations.of(context)!;
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(locale.register),
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
                        children: [
                          Spacer(),
                          AvatarPicker(
                            avatarList: AuthServices.defaultAvatars,
                            avatarRadius: 70,
                          ),
                          SizedBox(height: 12,),
                          Text("Avatar",style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),),
                          Spacer(),
                          TextFormField(
                            validator: (value) {
                              if(value == null || value.isEmpty){
                                return "Please enter name";
                              }else{
                                return null;
                              }
                            },
                            controller: provider.nameController,
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              hintText: locale.name,
                            ),
                          ),
                          SizedBox(height: 12,),
                          TextFormField(
                            validator: (value) {
                              bool isEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!);
                              if(value == null || value.isEmpty){
                                return "Please enter email";
                              }else if(!isEmail){
                                return "Please enter valid email";
                              }
                              else{
                                return null;
                              }
                            },
                            controller: provider.emailController,
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.mail),
                              hintText: locale.email,
                            ),
                          ),
                          SizedBox(height: 12,),
                          StatefulBuilder(
                            builder: (context, setState){
                              return TextFormField(
                                validator: (value) {
                                  if(value == null || value.isEmpty){
                                    return "Please enter password";
                                  }else if(value.length < 6){
                                    return "must be length more than 6 numbers";
                                  }else{
                                    return null;
                                  }
                                },
                                controller: provider.passwordController,
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
                                        setState((){});
                                      },
                                      child: Icon(isShowPassword? Icons.visibility_off : Icons.visibility)),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 12,),
                          StatefulBuilder(
                            builder: (context, setState){
                              return TextFormField(
                                validator: (value) {
                                  if(value != provider.passwordController.text){
                                    return "Password not matched";
                                  }else{
                                    return null;
                                  }
                                },
                                controller: provider.rePasswordController,
                                onTapOutside: (event) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                                obscureText: isShowPassword,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.lock),
                                  hintText: locale.rePassword,
                                  suffixIcon: InkWell(
                                      onTap: () {
                                        isShowPassword = !isShowPassword;
                                        setState((){});
                                      },
                                      child: Icon(isShowPassword? Icons.visibility_off : Icons.visibility)),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 12,),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter phone number";
                              } else if (value.length != 11) {
                                return "Phone number must be 11 digits";
                              }
                              return null;
                            },
                            controller: provider.phoneController,
                            keyboardType: TextInputType.phone,
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.phone),
                              hintText: locale.phoneNumber,
                            ),
                          ),
                          SizedBox(height: 12,),
                          Spacer(),
                          CustomBtn(
                              isExpanded: true,
                              isLoading: provider.isLoading,
                              onTap: () async{
                                bool success = await provider.createAccount(context);
                                if(success){
                                  Navigator.pushNamedAndRemoveUntil(context, RouteName.login, (route) => false);
                                }
                              }, text: locale.createAccount),
                          Spacer(),
                          Text.rich(
                              TextSpan(
                                  text: locale.haveAccount,
                                  children: [
                                    TextSpan(
                                        text: locale.login,style: theme.textTheme.bodyLarge!.copyWith(
                                        color: AppColors.secondaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                        decorationColor: AppColors.secondaryColor
                                    ),
                                        recognizer: TapGestureRecognizer()..onTap = () {
                                          Navigator.pushReplacementNamed(context, RouteName.login);
                                        }
                                    )
                                  ]
                              )
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
