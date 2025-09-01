import '../network/google_api_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'events/auth_event.dart';
import 'states/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  final GoogleApiClient googleApiClient;
  bool _isAdmin = false;

  bool isAdmin() {
    return _isAdmin;
  }

  AuthBloc(this.googleApiClient) : super(AuthBaseState()) {
    on<AuthStartedEvent>((event, emit) async {
      emit(AuthLoadingState());
      final result = await googleApiClient.signIn();
      if (result is Success) {
        _isAdmin = true;
        emit(AuthSuccessfulState(result.name));
      } else if(result is NoAdminFailure) {
        emit(AuthFailedState("You're not whitelisted"));
      } else {
        emit(AuthFailedState("Something went wrong"));
      }
    });

    on<AuthCheckEvent>((event, emit) async {
      final result = await googleApiClient.trySignIn();
      if(result is Success) {
        _isAdmin = true;
        emit(AuthSuccessfulState(result.name));
      } else {
        _isAdmin = false;
        emit(AuthBaseState());
      }
    });

    on<LogoutEvent>((event, emit) {
      googleApiClient.signOut();
      _isAdmin = false;
      emit(AuthBaseState());
    });
  }
}