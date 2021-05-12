import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wasfat_web/helper/constants.dart';
import 'package:wasfat_web/models/dish.dart';

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
  Widget build(BuildContext context) {
    final size = context.mediaQuerySize;

    return SliverAppBar(
      backgroundColor: (_barHeight == kToolbarHeight)
          ? Colors.amber[700]
          : (_barHeight < 90)
          ? Colors.amber[500]
          : (_barHeight < 120)
          ? Colors.amber[300]
          : Colors.white70,
      expandedHeight: size.height * 0.35,
      pinned: true,
      stretch: true,
      centerTitle: true,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
            setState(() => _barHeight = constraints.biggest.height);
          });
          return FlexibleSpaceBar(
            centerTitle: true,
            title: Text(
              (_barHeight == kToolbarHeight) ? dish.name : '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            background: Stack(children: [
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
                        if (dish.rating != null)
                          Container(
                            child: Row(
                              children: [
                                Text(dish.rating.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    )),
                                const Icon(
                                  Icons.star,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        Text(
                          dish.name,
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )),
            ]),
          );
        },
      ),
    );
  }
}
