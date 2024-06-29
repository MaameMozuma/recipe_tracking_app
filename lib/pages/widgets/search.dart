import 'package:flutter/material.dart';
import 'package:team_proj_leanne/model/meal.dart';

class CustomSearchBar extends StatefulWidget {

  final String placeholder;
  final Future<List<Meal>> Function(String) filterMeals;
  final Function(List<Meal>) onFilteredData;

  const CustomSearchBar({super.key,
    required this.placeholder,
    required this.filterMeals,
    required this.onFilteredData,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    //_searchController.text = widget.placeholder;
    return TextField( ///used to create the search bar
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: widget.placeholder,
                    hintStyle: const TextStyle(color: Color.fromRGBO(202, 201, 201, 1)),
                    prefixIcon: const Icon(Icons.search, color: Color.fromRGBO(202, 201, 201, 1.0),),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.0),
                      borderSide: const BorderSide(color: Color.fromRGBO(196, 195, 195, 1)) ,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.0),
                      borderSide: const BorderSide(color: Color.fromRGBO(196, 195, 195, 1), width: 1.0), // Focused border color and width
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.0),
                      borderSide: const BorderSide(color: Color.fromRGBO(186, 186, 186, 1), width: 2.0), // Focused border color and width
                    ),
                    filled: true,
                    fillColor: Colors.white, 
                  ),
                  onChanged: (query) async {
                    if (query.isNotEmpty) {
                      final filteredData = await widget.filterMeals(query);
                      widget.onFilteredData(filteredData);
                    }
                    else{
                      setState(() {
                        widget.onFilteredData([]);
                      });
                    } 
                  }           
                );
  }
}


