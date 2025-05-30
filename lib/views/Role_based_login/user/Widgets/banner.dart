import 'package:flutter/material.dart';

class MyBanner extends StatelessWidget {
  const MyBanner({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.25,
      width: size.width,
      color: Colors.cyan.shade200,
      child: Padding(
        padding: EdgeInsets.only(left: 27),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Шинэ цуглуулга",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -2,
                    fontFamily: 'Roboto', // Roboto шрифт
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "20",
                      style: TextStyle(
                        fontSize: 40,
                        height: 0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -3,
                        fontFamily: 'Roboto', // Roboto шрифт
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "%",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Roboto', // Roboto шрифт
                          ),
                        ),
                        Text(
                          "off",
                          style: TextStyle(
                            fontSize: 10,
                            letterSpacing: -1.5,
                            fontWeight: FontWeight.bold,
                            height: 0.6,
                            fontFamily: 'Roboto', // Roboto шрифт
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                MaterialButton(
                  onPressed: () {},
                  color: Colors.black12,
                  child: Text(
                    "Одоо худалдаж аваарай",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'Roboto', // Roboto шрифт
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(
                "assets/12345.png",
                height: size.height * 0.40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
