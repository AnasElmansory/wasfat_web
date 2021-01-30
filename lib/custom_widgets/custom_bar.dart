import 'package:flutter/material.dart';

class CustomBar extends StatefulWidget {
  final String name;
  final String imageUrl;
  final double rating;

  const CustomBar({Key key, this.name, this.imageUrl, this.rating})
      : super(key: key);

  @override
  _CustomBarState createState() => _CustomBarState();
}

class _CustomBarState extends State<CustomBar> {
  double _barHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SliverAppBar(
      backgroundColor: (_barHeight == 80)
          ? Colors.amber[700]
          : (_barHeight < 90)
              ? Colors.amber[500]
              : (_barHeight < 120)
                  ? Colors.amber[300]
                  : Colors.white70,
      expandedHeight: size.height * 0.3,
      pinned: true,
      stretch: true,
      centerTitle: true,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            setState(() => _barHeight = constraints.biggest.height);
          });
          return FlexibleSpaceBar(
            centerTitle: true,
            title: Text(
              (_barHeight == 80) ? widget.name : '',
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
                    image: widget.imageUrl,
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
                        if (widget.rating != null)
                          Container(
                            child: Row(
                              children: [
                                Text(widget.rating.toString(),
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
                          widget.name,
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
