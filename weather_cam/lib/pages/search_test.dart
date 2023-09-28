import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_capstone_weather/bloc/search/search_bloc.dart';

class SearchTest extends StatefulWidget {
  const SearchTest({Key? key}) : super(key: key);

  @override
  State<SearchTest> createState() => _SearchTestState();
}

class _SearchTestState extends State<SearchTest> {
  @override
  void initState() {
    super.initState();
    // read the context from Location Bloc gotten from Bloc Provider in main
    // call the add event of that Location Bloc
    context
        .read<SearchBloc>()
        .add(const FetchCityListEvent(cityQuery: 'London'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
      ),
    );
  }
}
