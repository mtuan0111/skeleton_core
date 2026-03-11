import 'package:skeleton_core/src/models/user_model.dart';

class UserState {
  final UserModel model;
  final String? greetingMessage;

  UserState({required this.model, this.greetingMessage});

  String? get username =>
      model.username?.isNotEmpty == true ? model.username : null;

  UserState copyWith({String? username, UserModel? model, String? greetingMessage}) {
    return UserState(
      model: model ?? this.model.copyWith(username: username),
      greetingMessage: greetingMessage ?? this.greetingMessage,
    );
  }
}

class UnAuthenticatedUser extends UserState {
  UnAuthenticatedUser({super.greetingMessage}) : super(model: UserModel());
}

class AuthenticatedUser extends UserState {
  AuthenticatedUser({required super.model, super.greetingMessage});
}
