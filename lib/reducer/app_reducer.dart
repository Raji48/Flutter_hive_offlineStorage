
import 'package:offlinestorage/ApiService/constants.dart';
import 'package:offlinestorage/models/feed_model.dart';
import 'package:offlinestorage/models/feed_state.dart';

FeedState feedReducer(FeedState state,dynamic action){
  FeedState newState = state;

  switch (action.type) {

    case FEED_REQUEST:
      newState.error = null;
      newState.loading = true;
      newState.feed = null;
      return newState;

    case FEED_SUCCESS:
      newState.error = null;
      newState.loading = false;
      newState.feed =  FeedModel.fromJson(action.payload);
      return newState;

    case FEED_FAILURE:
      newState.error = action.error;
      newState.loading = false;
      newState.feed = null;
      return newState;

    case FEED_CLEAR_PROPS:
      if(action.payload == "true"){
        newState.error = null;
        newState.loading = false;
        newState.feed = null;
      }
      return newState;

    default:
      return newState;
  }
}