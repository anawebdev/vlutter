import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import "dart:ui";
import "dart:math";
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";

class AnimalInfo {
  final String name;
  final String age;

  AnimalInfo(this.name, this.age);
}

final grey = Colors.grey[300];

class DashboardScreen extends StatefulWidget {
  _VlutterState createState() => _VlutterState();
}

class _VlutterState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  AnimationController animController;
  Animation animation;
  bool animationForward = true;
  var animals = List<AnimalInfo>.generate(
    5,
    (i) => AnimalInfo("name $i", "$i"),
  );

  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    animController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animation = CurveTween(curve: Curves.easeOut).animate(animController)
      ..addListener(() {
        setState(() {});
      });

    animController.forward();
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return MaterialApp(
          //   textDirection: TextDirection.ltr,

          home: Container(
            color: grey,
            child: PageView(
              scrollDirection: Axis.horizontal,
              pageSnapping: true,
              controller: pageController,
              children: [
                AddCard(),
                for (var i = 0; i < this.animals.length; i++)
                  DashboardCardPadded(
                      animation: animation, animal: this.animals[i])
              ],
              onPageChanged: (pageIndex) {
                animController.reset();
                animController.forward();
              },
            ),
          ),
        );
      },
    );
  }
}

class DashboardCardPadded extends AnimatedWidget {
  DashboardCardPadded({Key key, Animation animation, this.animal})
      : super(key: key, listenable: animation);

  AnimalInfo animal;

  Animation get animation => listenable;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 50),
        DashboardCard(animation: animation, animal: animal),
        SizedBox(height: 15),
      ],
    );
  }
}

class DashboardCard extends AnimatedWidget {
  DashboardCard({Key key, Animation animation, this.animal})
      : super(key: key, listenable: animation);
  AnimalInfo animal;
  Animation get animation => listenable;

  @override
  Widget build(BuildContext context) {
    const avatarSize = 150.0;

    const horizontalDivider = Divider(
      indent: 15,
      endIndent: 15,
      thickness: 0.8,
    );

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: avatarSize * 0.5,
            bottom: 0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.only(top: avatarSize / 2 + 15),
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(this.animal.name,
                      style: TextStyle(
                        fontSize: 14,
                        color: grey,
                      )),
                  horizontalDivider,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                          child: Thingy(percentage: 0.6, animation: animation)),
                      Expanded(
                          child: Thingy(percentage: 0.7, animation: animation)),
                      Expanded(
                          child:
                              Thingy(percentage: 0.25, animation: animation)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment(0, -1),
          child: Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              color: grey,
              border: Border.all(width: 2.0, color: Colors.grey[400]),
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                    'https://s3.eu-central-1.amazonaws.com/bea.vetevo/animals/725/avatar/064b32a0-99b2-11e8-aac2-79bd522c3aa9.jpeg'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Thingy extends AnimatedWidget {
  Thingy({Key key, this.percentage, Animation animation, this.animal})
      : super(key: key, listenable: animation);
  AnimalInfo animal;
  Animation get animation => listenable;
  final double percentage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: FittedBox(
              child: SizedBox(
                width: 60,
                height: 60,
                child: CustomPaint(
                  painter: Arc(percentage, animation.value),
                  child: Image.asset("assets/icon/vaccination_danger.png"),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15),
            child: Text("Better than passport",
                style: TextStyle(
                  fontSize: 8,
                  color: Colors.black,
                )),
          ),
        ],
      ),
    );
  }
}

class AddCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      const ListTile(
        leading: Icon(Icons.add_box),
        title: Text('Add your animal'),
        subtitle: Text("Add your animal's name and age"),
      ),
      ButtonTheme.bar(
        child: ButtonBar(
          children: <Widget>[
            FlatButton(
              child: const Text('Add animal'),
              onPressed: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => AddAnimalPage()));
              },
            ),
          ],
        ),
      ),
    ])));
  }
}

class AddAnimalPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String _date = "Not set";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Add pet')),
        body: Container(
            child: Builder(
                builder: (context) => Form(
                    key: _formKey,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 16.0),
                      child: Column(children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              icon: Icon(Icons.pets),
                              hintText: 'What the name of your pet',
                              labelText: 'Name *',
                            ),
                            onSaved: (String value) {
                              print('name $value');
                            },
                          ),
                        ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          elevation: 4.0,
                          onPressed: () {
                            DatePicker.showDatePicker(context,
                                theme: DatePickerTheme(
                                  containerHeight: 210.0,
                                ),
                                showTitleActions: true,
                                minTime: DateTime(2000, 1, 1),
                                maxTime: DateTime(2022, 12, 31),
                                onConfirm: (date) {
                              print('confirm $date');
                              _date =
                                  '${date.year} - ${date.month} - ${date.day}';
                              // setState();
                            },
                                currentTime: DateTime.now(),
                                locale: LocaleType.en);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 50.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.date_range,
                                            size: 18.0,
                                            color: Colors.teal,
                                          ),
                                          Text(
                                            " $_date",
                                            style: TextStyle(
                                                color: Colors.teal,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Text(
                                  "Change",
                                  style: TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                          ),
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                      ]),
                    )))));
  }
}

class Arc extends CustomPainter {
  double maxFill;
  double fill;

  Arc(this.maxFill, this.fill);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..color = Colors.pink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, 0, 2 * pi * maxFill * fill, false, paint);
  }

  @override
  bool shouldRepaint(Arc oldDelegate) => true;
}