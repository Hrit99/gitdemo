import 'package:fluttertasks/user.dart';

class Commit {
  final String? message;
  final String? sha;
  final User? author;
  final User? committer;

  Commit(
      {required this.message,
      required this.sha,
      required this.author,
      required this.committer});
}
