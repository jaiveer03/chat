import 'dart:developer';

import 'package:assignment/data/repositories/chat_repository.dart';
import 'package:assignment/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:assignment/presentation/blocs/auth_bloc/auth_event.dart';
import 'package:assignment/presentation/blocs/auth_bloc/auth_state.dart';
import 'package:assignment/presentation/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  final ChatRepository chatRepository;
  const LoginPage({super.key, required this.chatRepository});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController =
      TextEditingController(text: 'swaroop.vass@gmail.com');
  final TextEditingController _passwordController =
      TextEditingController(text: '@Tyrion99');
  String _selectedRole = "customer";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            log('Logged in user: id=${state.user.id}, role=${state.user.role}, email=${state.user.email}');

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => HomePage(
                  user: state.user,
                  chatRepository: widget.chatRepository,
                ),
              ),
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ToggleButtons(
                  isSelected: [
                    _selectedRole == "customer",
                    _selectedRole == "vendor"
                  ],
                  onPressed: (index) {
                    setState(() {
                      _selectedRole = index == 0 ? "customer" : "vendor";
                    });
                  },
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text("Customer"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text("Vendor"),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                state is AuthLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          final email = _emailController.text;
                          final password = _passwordController.text;
                          if (email.isEmpty || password.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Enter email & password")),
                            );
                            return;
                          }
                          context.read<AuthBloc>().add(
                                LoginRequested(
                                  email: email,
                                  password: password,
                                  role: _selectedRole,
                                ),
                              );
                        },
                        child: const Text("Login"),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
