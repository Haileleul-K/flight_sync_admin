import 'package:flight_sync_admin/core/base/app_session.dart';
import 'package:flight_sync_admin/features/dashboard/layout/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flight_sync_admin/core/styles/colors_theme.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'login_bloc/login_bloc.dart';
import 'login_bloc/login_event.dart';
import 'login_bloc/login_state.dart';
  final formKey = GlobalKey<FormState>();


class LoginPage extends StatelessWidget {
   LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    AppSession.getAccessToken().then((value) {
      if (value != null) {
        Get.offAll(() => const AppLayout());
      }
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          } else if (state is LoginSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Login successful'),
              ),
            );
            Get.to(() => const AppLayout());
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Use constraints.maxWidth to determine if we're on mobile or web
            if (constraints.maxWidth > 800) {
              return _WebLoginView();
            } else {
              return _MobileLoginView();
            }
          },
        ),
      ),
    );
  }
}

class _WebLoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left side with flight image
        Expanded(
          child: Container(
            color: Colors.transparent,
            child: Image.asset('assets/images/flight.png', fit: BoxFit.contain),
          ),
        ),
        // Right side with login form
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: _LoginContent(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MobileLoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 48),
            // Top image for mobile
            SizedBox(
              height: 200,
              child: Image.asset(
                'assets/images/flight.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 48),
            // Login content
            _LoginContent(),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}

class _LoginContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isWebView = MediaQuery.of(context).size.width > 800;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Logo
        // Icon(
        //   Icons.flight,
        //   size: isWebView ? 64 : 48,
        //   color: ColorThemes.primaryColor,
        // ),
        // const SizedBox(height: 24),
        // Welcome Back text
        Text(
          'Welcome Back',
          style: TextStyle(
            fontSize: isWebView ? 32 : 24,
            fontWeight: FontWeight.bold,
            color: ColorThemes.primaryColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Login to your FlightLog Admin account',
          style: TextStyle(
            fontSize: isWebView ? 16 : 14,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 48),
        // Login Form
         _LoginForm(),
      ],
    );
  }
}
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

class _LoginForm extends StatelessWidget {
   const _LoginForm();



  @override
  Widget build(BuildContext context) {
    final isWebView = MediaQuery.of(context).size.width > 800;
    final inputHeight = isWebView ? 45.0 : 70.0;

    return Form(
      key: formKey,
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Email field
        SizedBox(
          height: inputHeight,
          child: TextFormField(
           // onEditingComplete: () => FocusScopeNode(),
            controller: emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              if (!value.contains('@') || !value.contains('.')) {
                return 'Invalid email address';
              }
              return null;
            },
              style: TextStyle(fontSize: isWebView ? 15 : 14, height: 1.2),
            decoration: InputDecoration(
              filled: true,
              fillColor: ColorThemes.inputGreyColor,
              prefixIcon: Icon(
                Icons.email_outlined,
                size: isWebView ? 20 : 18,
              ),
              hintText: 'admin@flightlog.com',
              hintStyle: TextStyle(fontSize: isWebView ? 15 : 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 0,
              ),
              isDense: true,
              
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Password field
        SizedBox(
          height: inputHeight,
          child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              return null;
            },
           controller: passwordController,
            obscureText: true,
            style: TextStyle(fontSize: isWebView ? 15 : 14, height: 1.2),
            decoration: InputDecoration(
              
              filled: true,
              fillColor: ColorThemes.inputGreyColor,
              prefixIcon: Icon(Icons.lock_outline, size: isWebView ? 20 : 18),
              hintText: '••••••••',
              hintStyle: TextStyle(fontSize: isWebView ? 15 : 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 0,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
               
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.red),
              ),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Forgot Password link
        // Align(
        //   alignment: Alignment.centerRight,
        //   child: TextButton(
        //     onPressed: () {
        //       // TODO: Implement forgot password
        //     },
        //     child: Text(
        //       'Forgot Password?',
        //       style: TextStyle(
        //         color: Colors.grey[600],
        //         fontSize: isWebView ? 14 : 12,
        //       ),
        //     ),
        //   ),
        // ),
        // const SizedBox(height: 24),
        // // Login button
        BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return SizedBox(
              height: inputHeight,
              child: ElevatedButton(
                onPressed: state is LoginLoading
                    ? null
                    : () {
                        if (formKey.currentState!.validate()) {

                          Logger().f('from _LoginForm ${emailController.text} ${passwordController.text}');
                        context.read<LoginBloc>().add(
                               LoginSubmitted(
                                email: emailController.text,
                                password: passwordController.text,
                              ),
                            );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorThemes.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                 // padding: EdgeInsets.zero,
                 
                ),
                child: state is LoginLoading
                    ? SizedBox(
                        height: isWebView ? 20 : 16,
                        width: isWebView ? 20 : 16,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Text(
                        'Login',
                        style: TextStyle(
                          fontSize: isWebView ? 15 : 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            );
          },
        ),
      ],
      ),
    );
  }
}
