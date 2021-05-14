import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_web/helper/constants.dart';
import 'package:wasfat_web/models/dish.dart';
import 'package:wasfat_web/providers/auth_provider.dart';
import 'package:wasfat_web/providers/dishes_provider.dart';

class DishCustomBar extends StatefulWidget {
  final Dish dish;

  const DishCustomBar({Key? key, required this.dish}) : super(key: key);

  @override
  _DishCustomBarState createState() => _DishCustomBarState();
}

class _DishCustomBarState extends State<DishCustomBar> {
  double _barHeight = 0.0;
  Dish get dish => widget.dish;

  @override
  void initState() {
    context.read<DishesProvider>().listenDishLikes(dish.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = context.mediaQuerySize;
    final dishesProvider = context.watch<DishesProvider>();

    return Container(
      height: size.height * 0.35,
      child: Stack(
        children: [
          Positioned(
            width: size.width,
            height: size.height * 0.3,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: const Radius.circular(100),
              ),
              child: FadeInImage.assetNetwork(
                image: corsBridge + (dish.dishImages?.first ?? ''),
                fit: BoxFit.cover,
                placeholder: 'assets/transparent_logo.ico',
              ),
            ),
          ),
          Positioned(
              height: size.height * 0.06,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: const Radius.circular(30),
                      bottomLeft: const Radius.circular(30)),
                  color: Colors.amber[700],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (dish.rating != null) _dishRating(dish.rating),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      child: Text(
                        dish.name,
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          Positioned(
            left: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  IconButton(
                    hoverColor: GFColors.TRANSPARENT,
                    splashColor: GFColors.TRANSPARENT,
                    icon: isLiked(dishesProvider.oneDishLikes)
                        ? const Icon(
                            Icons.thumb_up,
                            color: Colors.blue,
                          )
                        : const Icon(
                            Icons.thumb_up_outlined,
                            color: Colors.grey,
                          ),
                    onPressed: isLiked(dishesProvider.oneDishLikes)
                        ? () async => await dishesProvider.unlikeDish(dish.id)
                        : () async => await dishesProvider.likeDish(dish.id),
                  ),
                  Text(dishesProvider.oneDishLikes.length.toString()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

bool isLiked(List<String> likes) {
  final userId = Get.context!.read<Auth>().wasfatUser?.uid;

  if (likes.contains(userId))
    return true;
  else
    return false;
}

String getRatingValue(Map<String, int>? rating) {
  if (rating?.isEmpty ?? true) return '0';
  final sum = rating!.values.reduce((valueF, valueL) => valueF + valueL);
  final average = (sum / rating.values.length).toPrecision(1);
  return average.toString();
}

Widget _dishRating(Map<String, int>? rating) {
  final ratingValue = getRatingValue(rating);
  return Container(
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            ratingValue,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Icon(
          Icons.star,
          size: 25,
          color: Colors.white,
        ),
      ],
    ),
  );
}
