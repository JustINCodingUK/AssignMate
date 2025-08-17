abstract interface class AuthEvent {}

class AuthStartedEvent implements AuthEvent {}

class AuthCheckEvent implements AuthEvent {}

class LogoutEvent implements AuthEvent {}