// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'search_bloc.dart';

enum SearchStatus {
  initial,
  loading,
  loaded,
  error,
}

class SearchState extends Equatable {
  final SearchStatus status;
  final List<City> cities;
  final String error;

  const SearchState({
    required this.status,
    required this.cities,
    required this.error,
  });

  factory SearchState.initial() {
    return const SearchState(
      status: SearchStatus.initial,
      cities: [],
      error: "No Errors",
    );
  }

  @override
  List<Object> get props => [
        status,
        cities,
        error,
      ];

  @override
  String toString() {
    return ('status: $status, cities: $cities, error: $error');
  }

  SearchState copyWith({
    SearchStatus? status,
    List<City>? cities,
    String? error,
  }) {
    return SearchState(
      status: status ?? this.status,
      cities: cities ?? this.cities,
      error: error ?? this.error,
    );
  }
}
