// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Repo _$RepoFromJson(Map<String, dynamic> json) => Repo(
      name: json['name'] as String?,
      description: json['description'] as String?,
      forks: json['forks'] as int?,
      open_issues: json['open_issues'] as int?,
      watchers: json['watchers'] as int?,
      private: json['private'] as bool?,
    );

Map<String, dynamic> _$RepoToJson(Repo instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'forks': instance.forks,
      'open_issues': instance.open_issues,
      'watchers': instance.watchers,
      'private': instance.private,
    };
