import 'package:flutter/material.dart';
import 'package:offlinestorage/models/feed_state.dart';

@immutable
class AppState {
  final FeedState feed;

  AppState({
    required this.feed,

  });
  factory AppState.initial() => AppState(
    feed: FeedState.initial(),
  );

  AppState copyWith({
    required FeedState? register,
  }) {
    return AppState(
        feed: register?? this.feed,
    );
  }
}
