
import 'package:notetify/onboard_screen/splash_content.dart';
import 'package:notetify/constant/PrimaryColor.dart';
import 'package:notetify/constant/ScreenSize.dart';
import 'package:notetify/shared_preferences/onboardPref.dart';
import 'package:notetify/utils/ScrollBehavior.dart';
import 'package:notetify/wrapper2.dart';
import 'package:flutter/material.dart';

class OnboardScreen extends StatefulWidget {
  @override
  _OnboardScreenState createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  int currentIndex = 0;
  PageController controller = PageController();
  @override
  Widget build(BuildContext context) {

    // List of contents
    List<Map<String, String>> data = [
      {
        "title": "Notetify",
        "subtitle": "Simpan catatan anda jadi lebih terstruktur",
        "image": "assets/Notes-rafiki.svg",
      },
      {
        "title": "Notetify",
        "subtitle": "Buatlah perencanaan dengan tepat",
        "image": "assets/Collaboration-rafiki.svg",
      },
      {
        "title": "Notetify",
        "subtitle": "Simpan link agar tidak lupa",
        "image": "assets/www-amico.svg",
      }
    ];
 

 String _btnName ="Next";

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 3,
                child: ScrollConfiguration(
                  /// generate contents with PageView
                  behavior: MyBehavior(),
                                  child: PageView.builder(
                    controller: controller,
                      onPageChanged: (value) {
                        setState(() {
                          currentIndex = value;
                        });
                      },
                      itemCount: data.length,
                      itemBuilder: (context, i) => SplashContent(
                            title: data[i]['title'],
                            subTitle: data[i]['subtitle'],
                            image: data[i]['image'],
                          )),
                )),

            Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(35.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[

                      /// Dot indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                            data.length, (index) => buildDot(index)),
                      ),

                      Spacer(),
                      
                      /// Next button for change for next content
                      SizedBox(
                          height: getHeight(context) * 0.07,
                          width: double.infinity,
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            onPressed: () {
                             
                              if(currentIndex<2){
                                setState(() {
                                  currentIndex++;
                                  controller.nextPage(duration: Duration(milliseconds: 800), curve: Curves.ease);
                                  
                                });
                              }
                              else{
                                
                                 Onboard.instance.setBoolValue("firstOpen", true);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Wrapper2()));
                              }
                            },
                            child: Text(_btnName, style: TextStyle(color: Colors.white),),
                            color: primaryColor,
                          )),
                          
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }


/// Dot Indicator
  AnimatedContainer buildDot(int index) {
    return AnimatedContainer(
      margin: EdgeInsets.only(right: 5),
      duration: Duration(milliseconds: 300),
      height: 6,
      width: currentIndex == index ? 20 : 6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color:
            currentIndex == index ? primaryColor : Colors.grey.withOpacity(0.7),
      ),
    );
  }
}
