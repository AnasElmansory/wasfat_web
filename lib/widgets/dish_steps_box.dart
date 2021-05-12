import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:wasfat_web/widgets/show_image_dialog.dart';

class DishStepsBox extends StatelessWidget {
  final String dishDescription;

  const DishStepsBox({Key? key, required this.dishDescription})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = context.mediaQuerySize;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
      margin: const EdgeInsets.all(12.0),
      width: size.width,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10)),
      child: HtmlWidget(
        dishDescription,
        onTapImage: (imageMeta) async {
          final url = imageMeta.sources.single.url;
          await showDialog(
            context: context,
            builder: (context) => ShowImageDialog(photoUrl: url),
          );
        },
        customStylesBuilder: (element) {
          if (element.localName == 'p')
            return {
              'font-size': '20',
              'text-align': 'right',
              'direction': 'rtl'
            };
          if (element.localName == 'h2')
            return {
              'font-size': '24',
              'color': 'red',
              'font-weight': 'bold',
              'text-align': 'right',
              'direction': 'rtl',
            };
        },
      ),
    );
  }
}
