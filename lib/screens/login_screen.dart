import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zopmedia_assignment/bloc/login/login_bloc.dart';
import 'package:zopmedia_assignment/bloc/login/login_event.dart';
import 'package:zopmedia_assignment/bloc/login/login_state.dart';
import 'package:zopmedia_assignment/screens/dashboard.dart';
import 'package:zopmedia_assignment/screens/register_screen.dart';


class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/login.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: BlocConsumer<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state.status == LoginStatus.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage ?? "Login failed.")),
                );
              }

              if (state.status == LoginStatus.success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Login successful!")),
                );
                Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => Dashboard(),));
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  Container(),
                  Container(
                    padding: EdgeInsets.only(left: 35, top: 130),
                    child: Text(
                      'Welcome\nBack',
                      style: TextStyle(color: Colors.white, fontSize: 33),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.5,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 35),
                            child: Column(
                              children: [
                                TextField(
                                  controller: _emailController,
                                  onChanged: (value) => context
                                      .read<LoginBloc>()
                                      .add(EmailChanged(value)),
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    hintText: "Email",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30),
                                TextField(
                                  controller: _passwordController,
                                  onChanged: (value) => context
                                      .read<LoginBloc>()
                                      .add(PasswordChanged(value)),
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    hintText: "Password",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 40),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Sign in',
                                      style: TextStyle(
                                        fontSize: 27,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Color(0xff4c505b),
                                      child: state.status == LoginStatus.submitting
                                          ? CircularProgressIndicator(
                                              color: Colors.white, strokeWidth: 2)
                                          : IconButton(
                                              color: Colors.white,
                                              onPressed: () {
                                                context
                                                    .read<LoginBloc>()
                                                    .add(LoginSubmitted());
                                              },
                                              icon: Icon(Icons.arrow_forward),
                                            ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 40),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => MyRegister(),));
                                      },
                                      child: Text(
                                        'Sign Up',
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Color(0xff4c505b),
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        'Forgot Password',
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Color(0xff4c505b),
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
