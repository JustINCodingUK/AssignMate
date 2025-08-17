abstract interface class AuthState {}

class AuthBaseState implements AuthState {}

class AuthSuccessfulState implements AuthState {
  final String name;

  AuthSuccessfulState(this.name);
}

class AuthFailedState implements AuthState {
  final String message;

  AuthFailedState(this.message);
}