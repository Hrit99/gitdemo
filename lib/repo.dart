import 'package:flutter/material.dart';
import 'package:fluttertasks/commit.dart';
import 'package:json_annotation/json_annotation.dart';

part 'repo.g.dart';

@JsonSerializable()
class Repo {
  final String? name;
  final String? description;
  int? forks;
  int? open_issues;
  int? watchers;
  bool? private;
  ValueNotifier<Commit>? lastCommit;

  Repo(
      {required this.name,
      required this.description,
      required this.forks,
      required this.open_issues,
      required this.watchers,
      required this.private,
      this.lastCommit});

  factory Repo.fromJson(Map<String, dynamic> json) => _$RepoFromJson(json);

  Map<String, dynamic> toJson() => _$RepoToJson(this);
}
