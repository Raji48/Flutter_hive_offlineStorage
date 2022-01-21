
import 'package:offlinestorage/models/feed_model.dart';

class FeedState {
  bool? loading;
  dynamic error;
  FeedModel? feed;


  FeedState({
    this.loading,
    this.error,
    required this.feed,

  });
  factory FeedState.initial() => FeedState(
    loading: false,
    error: null,
    feed:null,
  );
}