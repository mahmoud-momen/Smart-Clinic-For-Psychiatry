import 'package:equatable/equatable.dart';

import 'article.dart';

class ArticlesModle extends Equatable {
  final String? status;
  final int? totalResults;
  final List<Article>? articles;

  const ArticlesModle({this.status, this.totalResults, this.articles});

  factory ArticlesModle.fromJson(Map<String, dynamic> json) => ArticlesModle(
        status: json['status'] as String?,
        totalResults: json['totalResults'] as int?,
        articles: (json['articles'] as List<dynamic>?)
            ?.map((e) => Article.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  List<Object?> get props => [status, totalResults, articles];
}

