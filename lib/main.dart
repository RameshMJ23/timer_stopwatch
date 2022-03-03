import 'dart:async';

import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {

  TabController tb;
  var hour = 0;
  var min = 0;
  var sec = 0;
  bool started = true;
  bool stopped = true;
  int timeForTimer = 0;
  String timeToShow = '';
  bool timeChecked = true;

  //stopwatch
  bool startIsPressed = true;
  bool stopIsPressed = true;
  bool resetIsPressed = true;
  String timeToDisplay = '00:00:00';
  var swatch = Stopwatch();
  var dur = const Duration(seconds: 1);

  void startTimer(){
    Timer(dur, keepRunning);
  }

  void keepRunning(){
    if(swatch.isRunning){
      startTimer();
    }
    setState(() {
      timeToDisplay = swatch.elapsed.inHours.toString().padLeft(2,"0") + ':' +
          (swatch.elapsed.inMinutes%60).toString().padLeft(2,'0')+ ':' +
          (swatch.elapsed.inSeconds%60).toString().padLeft(2,'0');
    });
  }

  void startStopWatch(){
    setState(() {
      stopIsPressed = false;
      startIsPressed = false;
      resetIsPressed = false;
    });
    swatch.start();
    startTimer();
  }

  void stopStopWatch(){
    setState(() {
      stopIsPressed = true;
      resetIsPressed = false;
      startIsPressed = true;
    });
    swatch.stop();
  }

  void resetStopWatch(){
    setState(() {
      resetIsPressed = true;
      stopIsPressed = true;
      startIsPressed = true;
    });
    swatch.stop();
    swatch.reset();
    timeToDisplay = '00:00:00';
  }

  @override
  void initState() {
    tb = TabController(length: 2, vsync: this);
    super.initState();
  }

  void start(){
    setState(() {
      started = false;
      stopped = false;
    });
    timeForTimer = (hour*60*60) + (min*60) + sec;
    Timer.periodic(Duration(seconds: 1), (t){
      setState(() {
        if(timeForTimer < 1 || timeChecked == false){
          t.cancel();
          timeChecked = true;
          started = true;
          stopped = true;
          if(timeForTimer == 0){
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => MyHomePage()));
          }

        }else if(timeForTimer < 3600) {
          int m = timeForTimer ~/60;
          int s = timeForTimer - (60*m);
          timeToShow = '${m.toString().padLeft(2,"0")} : ${s.toString().padLeft(2,"0")}';
          timeForTimer--;
        }else if(timeForTimer < 60){
          timeToShow = timeForTimer.toString().padLeft(2,"0");
          timeForTimer--;
        }else{
          int h = timeForTimer ~/3600;
          int t = timeForTimer - (3600*h);
          int m = t ~/ 60;
          int s = t - (60*m);
          timeToShow = '${h.toString()}:${m.toString().padLeft(2,"0")}:${s.toString().padLeft(2, "0")}';
          timeForTimer--;
        }
      });
    });
  }

  void stop(){
    setState(() {
      started = true;
      stopped = true;
      timeChecked = false;
    });
  }

  Widget stopWatch(){
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 6,
            child: Center(
              child:Text(
                timeToDisplay,
                style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w600),
              ),

            )
          ),

          Expanded(
            flex: 4,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonTheme(
                      height: 25.0,
                      minWidth: 150.0,
                      child: RaisedButton(
                          padding: EdgeInsets.all(25.0),
                          color: Colors.red,
                          child: Text('Stop / pause', style: TextStyle(fontSize: 20.0, color: Colors.white)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)
                          ),
                          onPressed: stopIsPressed ? null : stopStopWatch
                      ),
                    ),

                    SizedBox(
                      width: 20.0,
                    ),

                    ButtonTheme(
                      height: 25.0,
                      minWidth: 150.0,
                      child: RaisedButton(
                          padding: EdgeInsets.all(25.0),
                          color: Colors.deepPurpleAccent,
                          child: Text('Reset', style: TextStyle(fontSize: 20.0, color: Colors.white)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)
                          ),
                          onPressed: resetIsPressed ? null : resetStopWatch
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),

                ButtonTheme(
                  height: 30.0,
                  minWidth: 250.0,
                  child: RaisedButton(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      color: Colors.green,
                      child: Text('Start / Resume', style: TextStyle(fontSize: 20.0, color: Colors.white)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)
                      ),
                      onPressed: startIsPressed ? startStopWatch : null
                  ),
                )
              ],
            )
          ),

        ],
      ),
    );
  }

  Widget timer(){
    return Container(
      child: Column(
        children: [
          Expanded(
            flex: 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text("HOUR",style: TextStyle(fontSize: 15.0)),
                    ),
                    NumberPicker.integer(
                        initialValue: hour,
                        minValue: 0,
                        maxValue: 23,
                        onChanged: (number){
                          setState(() {
                            hour = number;
                          });
                        }
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text("MIN",style: TextStyle(fontSize: 15.0)),
                    ),
                    NumberPicker.integer(
                        initialValue: min,
                        minValue: 0,
                        maxValue: 59,
                        onChanged: (number){
                          setState(() {
                            min = number;
                          });
                        }
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text("SEC",style: TextStyle(fontSize: 15.0),),
                    ),
                    NumberPicker.integer(
                        initialValue: sec,
                        minValue: 0,
                        maxValue: 59,
                        onChanged: (number){
                          setState(() {
                            sec = number;
                          }
                        );
                      }
                    )
                  ],
                )
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(timeToShow, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),)
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  padding:EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                  child: Text('Start',style: TextStyle(fontSize: 15.0, color: Colors.white)),
                  color: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)
                  ),

                  onPressed: started ? start : null),
                SizedBox(width: 20.0),
                RaisedButton(
                    padding:EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0) ,
                    child: Text('Stop',style: TextStyle(fontSize: 15.0, color: Colors.white)),
                    color: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    onPressed: stopped ? null : stop)
              ],
            )
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Timer app'
        ),
        centerTitle:true,
        bottom: TabBar(
          tabs: [
            Text('Timer'),
            Text('Stopwatch'),
          ],
          labelStyle: TextStyle(
            fontSize: 20.0
          ),
          labelPadding: EdgeInsets.only(bottom: 10.0),
          unselectedLabelColor: Colors.white60,
          controller: tb,
        ),
      ),
      body: TabBarView(
        children: [
          timer(),
          stopWatch()
        ],
        controller: tb,
      ),
    );
  }
}
