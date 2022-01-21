import 'package:offlinestorage/models/app_state.dart';
import 'package:offlinestorage/reducer/app_reducer.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    feed: feedReducer(state.feed, action),
  );
}