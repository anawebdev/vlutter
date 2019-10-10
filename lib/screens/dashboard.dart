import "package:flutter/material.dart";
import "dart:ui";
import "dart:math";

class AnimalInfo {
  final String name;
  final String age;

  AnimalInfo(this.name, this.age);
}

final grey = Colors.grey[300];

class DashboardScreen extends StatefulWidget {
  _VlutterState createState() => _VlutterState();
}

class _VlutterState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
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

  static const Charcoal = Color(0xFF484848);
  static const SemiCharcoal = Color(0x66484848);
  static const OffWhite = Color(0xFFF4F4F4);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return MaterialApp(
          //   textDirection: TextDirection.ltr,
          theme: ThemeData(
              primaryColor: Color(0xFF49B2AE),
              errorColor: Color(0xFF808080),
              textTheme: TextTheme(
                headline: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                    color: Charcoal),
                display1: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                    color: Charcoal),
                display2: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                    color: SemiCharcoal),
                title: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Charcoal),
                body1: TextStyle(fontSize: 12.0, color: Charcoal),
                body2: TextStyle(fontSize: 12.0, color: Charcoal),
                subtitle: TextStyle(fontSize: 12.0, color: Charcoal),
                caption: TextStyle(fontSize: 12.0, color: Charcoal),
              )),

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
        BottomContainer(animal: animal)
      ],
    );
  }
}

class BottomContainer extends StatelessWidget {
  BottomContainer({Key key, this.animal}) : super(key: key);
  AnimalInfo animal;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 64.0,
        margin: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0), color: Colors.white),
        child: Row(
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.only(top: 20, left: 30, right: 20, bottom: 20),
              child: Image.asset("assets/icon/vaccination_danger.png",
                  width: 30, height: 30),
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Aus liebe zu ' + this.animal.name,
                    style: Theme.of(context).textTheme.title),
                Text('Teste auf Wurmbefall',
                    style: Theme.of(context).textTheme.display2),
              ],
            ))
          ],
        ));
  }
}

class DashboardCard extends AnimatedWidget {
  DashboardCard({Key key, Animation animation, this.animal})
      : super(key: key, listenable: animation);
  AnimalInfo animal;
  Animation get animation => listenable;

  @override
  Widget build(BuildContext context) {
    const avatarSize = 136.0;

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
            borderRadius: BorderRadius.circular(8.0),
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
                      style: Theme.of(context).textTheme.title),
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
                  horizontalDivider,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                          child: Thingy(percentage: 0.6, animation: animation)),
                      Expanded(
                          child: Thingy(percentage: 0.7, animation: animation)),
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
              child: Column(
                children: <Widget>[
                  Text("Impfung",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.display1),
                  Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text("Jetzt eintragen",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.display2))
                ],
              )),
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
              onPressed: () {/* ... */},
            ),
          ],
        ),
      ),
    ])));
  }
}

class Arc extends CustomPainter {
  double maxFill;
  double fill;
  static const PrimaryColor = Color(0xFF49B2AE);

  Arc(this.maxFill, this.fill);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..color = (this.maxFill > 0.5) ? PrimaryColor : Colors.pink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, 0, 2 * pi * maxFill * fill, false, paint);
  }

  @override
  bool shouldRepaint(Arc oldDelegate) => true;
}
