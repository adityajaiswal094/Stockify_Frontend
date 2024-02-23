// import 'package:flutter/material.dart';
// import 'package:flutter_redux/flutter_redux.dart';
// import 'package:redux/redux.dart';

class UserState {
  Map<String, dynamic> user;
  List<dynamic> favouriteStocks;
  bool isLoading;
  bool isLoggedIn;
  bool isError;

  UserState({
    required this.user,
    required this.favouriteStocks,
    required this.isError,
    required this.isLoading,
    required this.isLoggedIn,
  });

  factory UserState.initial() {
    return UserState(
        user: {},
        favouriteStocks: [],
        isError: false,
        isLoading: false,
        isLoggedIn: false);
  }

  UserState copyWith({
    Map<String, dynamic>? user,
    List<dynamic>? favouriteStocks,
    bool? isError,
    bool? isLoading,
    bool? isLoggedIn,
  }) {
    return UserState(
      user: user ?? this.user,
      favouriteStocks: favouriteStocks ?? this.favouriteStocks,
      isError: isError ?? this.isError,
      isLoading: isLoading ?? this.isLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}

class UserLoggedInAction {
  final Map<String, dynamic> payload;
  const UserLoggedInAction({required this.payload});
}

class UserLoggedOutAction {
  // final Map<String, dynamic> payload;
  // const UserLoggedOutAction({required this.payload});
}

class StoreFavouriteStocks {
  final List<dynamic> payload;
  const StoreFavouriteStocks({required this.payload});
}

class LoadingAction {
  final Map<String, bool> payload;
  const LoadingAction({required this.payload});
}

class ErrorAction {
  final Map<String, bool> payload;
  const ErrorAction({required this.payload});
}

UserState userReducer(UserState state, dynamic action) {
  if (action is UserLoggedInAction) {
    return state.copyWith(isLoggedIn: true, user: {...action.payload});
  }
  //
  else if (action is UserLoggedOutAction) {
    return UserState.initial();
  }
  //
  else if (action is StoreFavouriteStocks) {
    return state.copyWith(favouriteStocks: action.payload);
  }
  //
  else if (action is LoadingAction) {
    return state.copyWith(
        isError: action.payload['isError'],
        isLoading: action.payload['isLoading']);
  }
  //
  else if (action is ErrorAction) {
    return state.copyWith(
        isError: action.payload['isError'],
        isLoading: action.payload['isLoading']);
  }
  return state;
}
