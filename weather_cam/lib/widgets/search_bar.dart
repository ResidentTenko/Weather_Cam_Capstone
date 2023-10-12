// ignore_for_file: prefer_const_constructors, avoid_print, slash_for_doc_comments

/**
 * This page is a work in progress. It needs to be made stateless and converted into a widget.
 * It will be called in homepage and the bloc will be used on the widget.
 * We will not us search bloc. Instead we will call weather bloc - which will have a search event
 * state.fetchweatherbysearchingevent(input inquiry) as the on click with gesture detector
 */

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

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                horizontal: 12.0, vertical: 8.0), // Adjust padding as needed
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
              return ListTile(
                title: Text(state.cities[index].name),
                subtitle: Text(state.cities[index].region),
                trailing: Text(state.cities[index].country),
              );
            },
          );
        },
      )
    ]);
  }
}
