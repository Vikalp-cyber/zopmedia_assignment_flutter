import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState.initial()) {
    on<EmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email));
    });

    on<PasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
    });

    on<LoginSubmitted>(_onLoginSubmitted);
    on<RegisterSubmitted>(_onRegisterSubmitted);

  }
  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event, Emitter<LoginState> emit) async {
  emit(state.copyWith(status: LoginStatus.submitting, errorMessage: null));

  try {
    final response = await http.post(
      Uri.parse('https://zopmedia-assignment-backend.onrender.com/api/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': state.email, // API expects 'username'
        'password': state.password,
      }),
    );

    print("registration response: ${response.body}");

    if (response.statusCode == 201 || response.statusCode == 200) {
      emit(state.copyWith(status: LoginStatus.success));
    } else {
      final error = jsonDecode(response.body);
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: error['message'] ?? 'Registration failed',
      ));
    }
  } catch (e) {
    emit(state.copyWith(
      status: LoginStatus.failure,
      errorMessage: 'Something went wrong. Please try again.',
    ));
  }
}


  Future<void> _onLoginSubmitted(
      LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: LoginStatus.submitting, errorMessage: null));

    try {
      final response = await http.post(
        Uri.parse('https://zopmedia-assignment-backend.onrender.com/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': state.email, // Your API expects 'username'
          'password': state.password,
        }),
      );

      print("response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // You could store token using shared_preferences or secure storage
        // Example: final token = data['token'];

        emit(state.copyWith(status: LoginStatus.success));
      } else {
        final error = jsonDecode(response.body);
        emit(state.copyWith(
          status: LoginStatus.failure,
          errorMessage: error['message'] ?? 'Login failed',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: 'Something went wrong. Please try again.',
      ));
    }
  }
}
