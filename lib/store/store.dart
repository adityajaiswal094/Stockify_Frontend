import 'package:redux/redux.dart';
import 'package:stockify/store/user_reducer.dart';

final Store<UserState> store = Store<UserState>(
  userReducer,
  initialState: UserState.initial(),
);
