import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zopmedia_assignment/bloc/login/login_bloc.dart';
import 'package:zopmedia_assignment/bloc/login/login_event.dart';
import 'package:zopmedia_assignment/bloc/login/login_state.dart';


class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text("Login")),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocConsumer<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state.isSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Login Successful")),
                );
              } else if (state.isFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Invalid credentials")),
                );
              }
            },
            builder: (context, state) {
              final bloc = context.read<LoginBloc>();

              return Column(
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: "Email"),
                    onChanged: (val) => bloc.add(EmailChanged(val)),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(labelText: "Password"),
                    obscureText: true,
                    onChanged: (val) => bloc.add(PasswordChanged(val)),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: state.isSubmitting
                        ? null
                        : () => bloc.add(LoginSubmitted()),
                    child: state.isSubmitting
                        ? CircularProgressIndicator()
                        : Text("Login"),
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
