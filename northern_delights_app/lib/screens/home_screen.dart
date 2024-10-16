import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:northern_delights_app/widgets/food_place_cards.dart';
import 'package:northern_delights_app/widgets/category_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Northern Delights',
          style: TextStyle(
            color: const Color.fromARGB(255, 255, 255, 255),
            fontSize: 35,
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: false,
        backgroundColor: const Color.fromARGB(255, 0, 85, 255),
        elevation: 0.0,
        actions: [
          GestureDetector(
            child: Container(
              alignment: Alignment.center,
              width: 55,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 85, 255),
                  borderRadius: BorderRadius.circular(10)),
              child: SvgPicture.asset(
                'assets/icons/profile-circle.svg',
                height: 40,
                width: 40,
                color: Colors.white60,
              ),
            ),
            onTap: () {},
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi, MangDags',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
              ),
            ),
            Text(
              'Looking for gastropub',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 15, left: 20, right: 20),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.11),
                        blurRadius: 40,
                        spreadRadius: 0.0,
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                        prefixIcon: Opacity(
                          opacity: 0.5,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: SvgPicture.asset('assets/icons/search.svg'),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        )),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20, left: 20, bottom: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Popular Gastropubs',
                    textAlign: TextAlign.start,
                    softWrap: false,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
                    alignment: Alignment.centerRight,
                    child: Text(
                      'View All',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black45,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            CategoryButton(), 

            const SizedBox(height: 20),
            // Limit the height of the ListView to prevent overflow
            SizedBox(
              height: 390, // Set a fixed height for the horizontal list
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ShowFoodPlace(
                    foodCardImage: AssetImage('assets/images/empanada.jpg'),
                    foodCardTitle: 'Empanada Ilocos',
                    foodCardLocation: 'Bantay, Ilocos Sur',  
                  ),
                  const SizedBox(width: 20),
                  ShowFoodPlace(
                    foodCardImage: AssetImage('assets/images/empanada_2.jpg'),
                    foodCardTitle: 'Vigan Empanadahan',
                    foodCardLocation: 'Vigan City',
                  ),
                  const SizedBox(width: 20),
                  ShowFoodPlace(
                    foodCardImage: AssetImage('assets/images/empanada_2.jpg'),
                    foodCardTitle: 'Vigan Empanada',
                    foodCardLocation: 'Vigan City',
                  ),
                  const SizedBox(width: 20),
                  ShowFoodPlace(
                    foodCardImage: AssetImage('assets/images/empanada_2.jpg'),
                    foodCardTitle: 'Vigan Empands',
                    foodCardLocation: 'Vigan Ilocos Sur',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
 Widget buildCategoryButton(String label, Color bgColor, Color textColor) {
  return ElevatedButton(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(bgColor), // Background color
      padding: WidgetStateProperty.all<EdgeInsets>(
        EdgeInsets.symmetric(
          vertical: 5, // Adjust for vertical space
          horizontal: 20, // Adjust for horizontal space
        ),
      ), // Padding to make space for the text
      elevation: WidgetStateProperty.resolveWith<double?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.pressed)) {
            return 10;
          }
          return 2; // Default elevation
        },
      ),
      overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.focused)) {
              return Colors.red.withOpacity(0.2);
            }
            if (states.contains(WidgetState.hovered)) {
              return Colors.green.withOpacity(0.2);
            }
            if (states.contains(WidgetState.pressed)) {
              return Colors.blue.withOpacity(0.2);
            }
            return null;
          },
        ),
      ),
      onPressed: () {},
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16, // Larger text size for better readability
          color: textColor, // Use dynamic text color
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}


class ShowFoodPlace extends StatelessWidget {
  final AssetImage foodCardImage;
  final String foodCardTitle;
  final String foodCardLocation;

  const ShowFoodPlace({
    required this.foodCardImage,
    required this.foodCardTitle,
    required this.foodCardLocation,
    super.key,
    });

  @override
  Widget build(BuildContext context) {
    return FoodPlaceCards(
      foodCardImage: foodCardImage,
      foodCardTitle: foodCardTitle,
      foodCardLocation: foodCardLocation,
    );
  }
}