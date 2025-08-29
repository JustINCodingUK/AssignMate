import 'package:assignmate/bloc/auth_bloc.dart';
import 'package:assignmate/bloc/events/auth_event.dart';
import 'package:assignmate/bloc/states/auth_state.dart';
import 'package:assignmate/ext/pad.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AuthRoute extends StatelessWidget {
  const AuthRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AssignMate: Admin")),
      body: BlocConsumer<AuthBloc, AuthState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Warning!",
                style: Theme.of(context).textTheme.displayMedium,
              ).pad(16),

              Text(
                "You're about to login to AssignMate Admin. Successful login would only occur if your email is whitelisted by the developer. Contact the developer for further information.\n\nIf you've been whitelisted, please use the email you requested access for.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ).pad(16),

              ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(AuthStartedEvent());
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/google.png', height: 24.0),
                    SizedBox(width: 8.0),
                    Text("Login with Google"),
                  ],
                ),
              ).pad(16),
            ],
          );
        },
        listener: (context, state) {
          if (state is AuthSuccessfulState) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text("AssignMate Admin"),
                  content: Column(
                    children: [
                      Icon(Icons.check).padSymmetric(horizontal: 16),
                      SizedBox(width: 16.0),
                      Text(
                        "Sign in successful.\nWelcome ${state.name}",
                      ).padSymmetric(horizontal: 16),

                      ElevatedButton(
                        onPressed: () {
                          context.push("/");
                        },
                        child: Text("Ok"),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is AuthFailedState) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("AssignMate Admin"),
                  content: Row(
                    children: [
                      Icon(Icons.error).padSymmetric(horizontal: 16),
                      SizedBox(width: 16.0),
                      Text(state.message).padSymmetric(horizontal: 16),
                    ],
                  ),
                );
              },
            );
          } else if (state is AuthLoadingState) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) => Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
