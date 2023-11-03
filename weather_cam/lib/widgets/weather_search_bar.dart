// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_application/blocs/search/search_bloc.dart';
import 'package:flutter_application/models/city_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherSearchBar extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();
  final Function(City city) onCitySelected;

  WeatherSearchBar({
    Key? key,
    required this.onCitySelected,
  }) : super(key: key);

  // Method to clear the text field
  void clearSearchField() {
    _searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: TextField(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10.0, vertical: 5.0), // Adjust padding as needed
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
                context.read<SearchBloc>().add(
                      FetchCityListEvent(cityQuery: query),
                    );
              }
            },
            
          ),
        ),
        BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white.withOpacity(0.90),
              ),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: state.cities.length,
                itemBuilder: (context, index) {
                  final city = state.cities[index];
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.purple.withOpacity(0.20),
                          width: 2.0),
                    ),
                    child: ListTile(
                      title: Text(state.cities[index].name),
                      subtitle: Text(state.cities[index].region),
                      trailing: Text(state.cities[index].country),
                      onTap: () {
                        onCitySelected(city);
                        context.read<SearchBloc>().add(ResetSearchListEvent());
                      },
                    ),
                  );
                },
              ),
            ),
          );
        }),
      ],
    );
  }
}
