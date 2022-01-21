
import 'package:offlinestorage/ApiService/apicontroller.dart';
import 'package:offlinestorage/ApiService/constants.dart';
import 'package:offlinestorage/models/app_state.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

ThunkAction<AppState> feedaction(data) =>
        (Store<AppState> store) => getDioApi(
            feedUrl,
        [
          FEED_REQUEST,
          FEED_SUCCESS,
          FEED_FAILURE,
        ],
        store);

clearpropsrequest(data) {
  return ResponseModal.responseResult(data.toString(), FEED_CLEAR_PROPS);
}

ThunkAction<AppState> clearpropsviewrequest(data) =>
        (Store<AppState> store) => store.dispatch(clearpropsrequest(data));
