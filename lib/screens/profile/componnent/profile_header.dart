import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileHeaderComponnent extends StatefulWidget {
  final VoidCallback press;
  final String title;
  final String image;
  const ProfileHeaderComponnent(
      {Key? key, required this.press, required this.title, required this.image})
      : super(key: key);

  @override
  _ProfileHeaderComponnentState createState() =>
      _ProfileHeaderComponnentState();
}

class _ProfileHeaderComponnentState extends State<ProfileHeaderComponnent> {
  int? selected;
  String lang = '';

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language').toString();
    });
  }

  @override
  void initState() {
    getLang();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: widget.press,
      child: Column(
        children: [
          Image(
            image: AssetImage(widget.image),
            color: Colors.black,
          ),
          SizedBox(
            width: w * 0.2,
            child: Text(
              widget.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                  fontSize: w * 0.04,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }
}
