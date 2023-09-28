import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_capstone_weather/bloc/location/location_bloc.dart';

class LocationTest extends StatefulWidget {
  const LocationTest({Key? key}) : super(key: key);

  @override
  State<LocationTest> createState() => _LocationTestState();
}

class _LocationTestState extends State<LocationTest> {
  @override
  void initState() {
    super.initState();
    // read the context from Location Bloc gottem from Bloc Provider in main
    // call the add event of that Location Bloc
    context.read<LocationBloc>().add(FetchLocationEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
      ),
      // when we use weatherbloc in the bloc builder, we will listen to location bloc as well using bloc listener
      body: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {
          if (state.status == LocationStatus.loaded) {
            return Center(
              child: Text(
                'Longitude: ${state.longitude}',
                style: const TextStyle(
                  fontSize: 24, // Adjust the font size as needed
                  color: Colors.black, // Adjust the text color as needed
                ),
              ),
            );
          } else if (state.status == LocationStatus.error) {
            return Center(
              child: Text(
                  'Error: ${state.error}'), // Adjust this as per your error handling
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            ); // Show loading indicator when status is not loaded or error
          }
        },
      ),
    );
  }
}
