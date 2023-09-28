// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_capstone_weather/bloc/search/search_bloc.dart';

class SearchTestField extends StatefulWidget {
  const SearchTestField({Key? key}) : super(key: key);

  @override
  State<SearchTestField> createState() => _SearchTestFieldState();
}

class _SearchTestFieldState extends State<SearchTestField> {
  final TextEditingController _searchController = TextEditingController();
  bool showList = false;

  // Your function to fetch search results
  void fetchSearchResults() {
    setState(() {
      showList = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search ListTile'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0), // Adjust padding as needed
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                hintStyle: TextStyle(color: Colors.grey[800]),
                hintText: "Search",
                fillColor: Colors.white70,
              ),
              controller: _searchController,
              onSubmitted: (query) {
                if (query.isNotEmpty && query.length >= 3) {
                  context
                      .read<SearchBloc>()
                      .add(FetchCityListEvent(cityQuery: query));
                  fetchSearchResults();
                }
              },
            ),
          ),
          BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: state.cities.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      print(
                          'City Url at $index: ${state.cities[index].url}');
                    },
                    child: ListTile(
                      title: Text(state.cities[index].name),
                      subtitle: Text(state.cities[index].region),
                      trailing: Text(state.cities[index].country),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
