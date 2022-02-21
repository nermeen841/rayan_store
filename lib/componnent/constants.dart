// ignore_for_file: avoid_print

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';

Color mainColor = const Color(0xfffe4194);
Color mainColor2 = const Color(0xffff979c);

///////////////////////////////////////////////////////////////////////

homeBottomSheet({context, child}) {
  var w = MediaQuery.of(context).size.width;

  return showModalBottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(w * 0.07),
          topLeft: Radius.circular(w * 0.07)),
    ),
    isDismissible: true,
    context: context,
    builder: (context) => child,
  );
}
////////////////////////////////////////////////////////////////////////////////////

customCachedNetworkImage(
    {required String url, required context, required BoxFit fit}) {
  try {
    // ignore: unnecessary_null_comparison
    if (url == null || url == "") {
      return Icon(
        Icons.error,
        color: HexColor("#AB0D03"),
      );
    } else {
      return Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        child: (Uri.parse(url).isAbsolute)
            ? CachedNetworkImage(
                imageUrl: url,
                fit: fit,
                placeholder: (context, url) => Container(),
                errorWidget: (context, url, error) {
                  return Icon(
                    Icons.error,
                    color: HexColor("#AB0D03"),
                  );
                })
            : Icon(
                Icons.error,
                color: HexColor("#AB0D03"),
              ),
      );
    }
  } catch (e) {
    print(e.toString());
  }
}

///////////////////////////////////////////////////////////////////////////////

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

////////////////////////////////////////////////////////////

String parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String parsedString = parse(document.body!.text).documentElement!.text;
  return parsedString;
}

//////////////////////////////////////////////////////////////////////////////////////

