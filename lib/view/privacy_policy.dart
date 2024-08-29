import 'package:flutter/material.dart';

class PrivacyPolicy extends StatefulWidget {
  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.deepPurple,
                        size: 25,
                      ),
                      onPressed: () {
                        setState(() {
                          Navigator.pop(context);
                        });
                      }),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      "Privacy Policy",
                      style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w800,
                          fontSize: 23),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Vivamus eget aliquam dui. Integer eu arcu \nvel arcu suscipit ultrices quis non mauris. A\nenean scelerisque, sem eu dictum commod\no, velit nisi blandit magna, quis scelerisque ips\num lectus ut libero. Sed elit diam, dignissim a\nc congue quis, aliquam in purus. Proin ligul\na nulla, scelerisque quis venenatis pulvinar, \ncongue eget neque. Proin scelerisque metus\nsit amet dolor tempor vehicula. Sed laoreet\nquis velit vitae facilisis.',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 17,
                  color: const Color(0x9e979797),
                  letterSpacing: 0.006149999946355819,
                  height: 1.3333333333333333,
                ),
                textHeightBehavior:
                    TextHeightBehavior(applyHeightToFirstAscent: false),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Duis ut sapien eu urna laoreet maximus. Do\nnec nibh diam, vulputate vel nulla ut, viverra\ncongue turpis. Fusce consectetur posuere p\nurus, eget placerat nunc hendrerit at. Sed le\nctus dui, euismod a odio vitae, dictum dictum\nm justo. ',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 17,
                  color: const Color(0x9e979797),
                  letterSpacing: 0.006149999946355819,
                  height: 1.3333333333333333,
                ),
                textHeightBehavior:
                    TextHeightBehavior(applyHeightToFirstAscent: false),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'Lorem ipsum',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff000000),
                  letterSpacing: 0.006149999946355819,
                  height: 1.3333333333333333,
                ),
                textHeightBehavior:
                    TextHeightBehavior(applyHeightToFirstAscent: false),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'Duis ut sapien eu urna laoreet maximus. Do\nnec nibh diam, vulputate vel nulla ut, viverra\ncongue turpis.  ',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 17,
                  color: const Color(0x9e979797),
                  letterSpacing: 0.006149999946355819,
                  height: 1.3333333333333333,
                ),
                textHeightBehavior:
                    TextHeightBehavior(applyHeightToFirstAscent: false),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
