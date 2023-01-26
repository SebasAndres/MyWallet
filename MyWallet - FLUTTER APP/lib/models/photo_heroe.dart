import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PhotoHero extends StatelessWidget {
  const PhotoHero({ required this.photo, required this.onTap, required this.descr });

  final String photo;
  final VoidCallback onTap;
  final String descr;

  Widget build(BuildContext context) {
    TextStyle FONT_STYLE = GoogleFonts.cabinCondensed (color: Colors.black, fontSize: 16);

    return SizedBox(
      width: 350,
      height: 80,
      child: Hero(
        tag: photo,
        child: InkWell(
            onTap: onTap,
            child: Card(
              elevation: 20,
              color: Colors.indigo[100],
              child:
                Row (
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  /*
                  * Image.asset(
                    photo,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: 10),
                  *
                  * */
                  Text (descr, style: FONT_STYLE)
                ])
            ),
          ),
      ),
    );
  }
}