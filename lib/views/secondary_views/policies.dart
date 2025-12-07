import 'package:flutter/material.dart';
import 'package:iconicmusic/theme/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconicmusic/theme/shapes/app_bar_shape.dart';

class PoliciesView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Stack(children: [
              Positioned.fill(child: Container(color: colorsPalette[4])),
              Positioned.fill(
                  child: CustomPaint(
                    painter: customShape(bgColor: colorsPalette[3]),
                  )),
              AppBar(
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Colors.white,
                  ),
                  elevation: 0,
                  title: Text('Iconic Music',
                      style: GoogleFonts.rubikVinyl(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w700)))
            ])),
        body: Center(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                color: colorsPalette[4],
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Privacy Policy",
                        style: GoogleFonts.merriweather(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),

                      Text(
                        "Last updated: December 5, 2025",
                        style: GoogleFonts.merriweather(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(height: 25),
                      Text(
                        "This application developed by dnvdev respects the privacy of its users. "
                            "This app does not collect, store, or share any personal information.",
                        style: GoogleFonts.merriweather(
                          fontSize: 20,
                          height: 1.4,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(height: 25),
                      Text(
                        "1. No Information Collected",
                        style: GoogleFonts.merriweather(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "We do not collect any personal data, usage data, analytics, device identifiers, "
                            "or any type of information. No login, registration, email, or personal "
                            "identification is required to use the application.",
                        style: GoogleFonts.merriweather(
                          fontSize: 20,
                          height: 1.4,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(height: 25),
                      Text(
                        "2. No Sharing of Data",
                        style: GoogleFonts.merriweather(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Since no data is collected, no information is shared, sold, exchanged, "
                            "or transferred to third parties for any purpose.",
                        style: GoogleFonts.merriweather(
                          fontSize: 20,
                          height: 1.4,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(height: 25),
                      Text(
                        "3. No External Tracking",
                        style: GoogleFonts.merriweather(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "This application does not use cookies, tracking tools, analytics tools, "
                            "or third-party services that process information about the user.",
                        style: GoogleFonts.merriweather(
                          fontSize: 20,
                          height: 1.4,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(height: 25),
                      Text(
                        "4. Changes to This Policy",
                        style: GoogleFonts.merriweather(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "If the privacy policy changes in the future, the updated version will be "
                            "published here with a new date.",
                        style: GoogleFonts.merriweather(
                          fontSize: 20,
                          height: 1.4,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(height: 25),
                      Text(
                        "5. Contact",
                        style: GoogleFonts.merriweather(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "If you have questions about this Privacy Policy, you may contact:",
                        style: GoogleFonts.merriweather(
                          fontSize: 20,
                          height: 1.4,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Email: daniel.gonzalezubaque@gmail.com",
                        style: GoogleFonts.merriweather(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Developer: dnvdev",
                        style: GoogleFonts.merriweather(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )

                ))));
  }
}
