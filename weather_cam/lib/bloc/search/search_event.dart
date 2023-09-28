// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class FetchCityListEvent extends SearchEvent{
  final String cityQuery;
  const FetchCityListEvent({
    required this.cityQuery,
  });
}
