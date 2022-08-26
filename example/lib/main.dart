import 'package:flutter/material.dart';
import 'package:nopsuite_carousel_slider/effects/worm_effect.dart';
import 'package:nopsuite_carousel_slider/nopsuite_carousel_slider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smooth Page Indicator Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = PageController(viewportFraction: 0.8, keepPage: true);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final pages = List.generate(
        6,(index) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey.shade300,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: SizedBox(
            height: 280,
            child: Center(
                child: Text(
                  "Page $index",
                  style: const TextStyle(color: Colors.indigo),
                )),
          ),
        ));
    return Scaffold(
      appBar: AppBar(title: const Text("NopSuite Carousel slider")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              NopSuiteCarouselSlider(
                controller: controller,
                count: pages.length,
                itemBuilder: pages,
                effect: const WormEffect(
                  dotHeight: 8,
                  dotWidth: 16,
                  radius: 4,
                  dotColor: Colors.black26,
                  activeDotColor: Colors.black,
                  type: WormType.normal,
                  strokeWidth: 5,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

const colors = [
  Colors.red,
  Colors.green,
  Colors.greenAccent,
  Colors.amberAccent,
  Colors.blue,
  Colors.amber,
];
