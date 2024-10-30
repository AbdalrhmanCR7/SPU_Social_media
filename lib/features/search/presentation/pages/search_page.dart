import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: const Color(0xFFd5c48e),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            TextFormField(
              controller: _searchController,
              cursorColor: const Color(0xFFd5c48e),
              decoration: const InputDecoration(
                hintText: 'Search for people...',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFd5c48e)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFd5c48e)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                suffixIcon: Icon(Icons.search),
              ),
              onFieldSubmitted: (value) {

                print('Searching for: $value');
              },
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Person ${index + 1}'),
                    onTap: () {

                      print('Tapped on Person ${index + 1}');
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}