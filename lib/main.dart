// this is a stopwatch app..with ui and components both written in main.dart page

import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner:
          false, //to remove the "debug" banner in the top-right corner of the app
      home: MyHomeApp(),
    );
  }
}

class MyHomeApp extends StatefulWidget {
  //used stateful widget because the screen state will be changed or re-rendered after each second
  const MyHomeApp({Key? key}) : super(key: key);

  @override
  MyHomeAppState createState() => MyHomeAppState();
}

class MyHomeAppState extends State<MyHomeApp> {
  int seconds = 0, minutes = 0, hours = 0;
  String secondsDigit = "00", minutesDigit = "00", hoursDigit = "00";
  Timer? timer;
  bool started =
      false; // a switch-type variable to check whether the timer is paused or running

  List laps = []; //list to store the lap-timings

  //custom stop-timer function to pause the timer
  void stopTimer() {
    timer!.cancel();
    setState(() {
      started = false;
    });
  }

  //custom reset function to reset all the values
  void resetTimer() {
    timer!.cancel();
    setState(() {
      seconds = 0;
      minutes = 0;
      hours = 0;

      secondsDigit = "00";
      minutesDigit = "00";
      hoursDigit = "00";

      started = false;
    });
  }

  //custom function to add laps
  void addLaps() {
    String lap = "$hoursDigit : $minutesDigit : $secondsDigit";
    setState(() {
      laps.add(lap);
    });
  }

  //start-timer function: custom function to start the timer
  void startTimer() {
    //basic timer increment logic is written, to know more about "periodic" enum, hover over it
    started = true;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      int localSeconds = seconds + 1,
          localMinutes = minutes,
          localHours = hours;

      if (localSeconds > 59) {
        if (localMinutes > 59) {
          localHours++;
          localMinutes = 0;
        } else {
          localMinutes++;
          localSeconds = 0;
        }
      }

      setState(() {
        seconds = localSeconds;
        minutes = localMinutes;
        hours = localHours;

        secondsDigit = (seconds >= 10) ? "$seconds" : "0$seconds";
        minutesDigit = (minutes >= 10) ? "$minutes" : "0$minutes";
        hoursDigit = (hours >= 10) ? "$hours" : "0$hours";
      });
    });
  }

  final ScrollController _scrollController =
      ScrollController(); //ScrollController is used to manage the scrollable item, to know more, hover over the ScrollController data-type

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C2757),
      body: SafeArea(
        //used safe-area to prevent app bar from overlapping with status bar
        child: Padding(
          padding: const EdgeInsets.all(16),
          //this is main-column of the app
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //heading text
              const Center(
                child: Text(
                  'Stopwatch',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              //main timer text
              Center(
                child: Text(
                  '$hoursDigit:$minutesDigit:$secondsDigit',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 65,
                  ),
                ),
              ),

              //this container if for the laps-section
              Container(
                height: 400,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: const Color(0xFF323F68),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.builder(
                  //used to make a variable-length column, scrollable; since we don't know the exact length of tine-laps column...it is user dependent
                  controller: _scrollController,
                  itemCount: laps.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 25,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Lap ${index + 1} : ",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                "${laps[index]}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          const Divider(
                            color: Colors.white,
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              //this is the bottom-most row, for "Start/Pause", "Flag" and "Reset" options
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //the "Start/Pause" btn
                  Expanded(
                    //used because wanted to fill the entire row...flexibly...with this item only; i.e., whenever a widget wrapped inside an expanded widget gets opportunity to expand, then it expands
                    child: RawMaterialButton(
                      onPressed: () {
                        (!started)
                            ? startTimer()
                            : stopTimer(); //startTimer and stopTimer functions are called based on the truth value of 'started' variable
                      },
                      shape: const StadiumBorder(
                        //to create a border around any widget
                        side: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      child: Text(
                        (!started) ? "Start" : "Pause",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 8,
                  ),

                  //flag btn

                  //this IconButton can be used to just tap the btn, but if we want more properties, rather just tap...then we use Inkwell instead as IconButton does not provide properties such as: 'onLongPress' and 'onDrag', etc.
                  // IconButton(
                  //   color: Colors.white,
                  //   iconSize: 37,
                  //   onPressed: () {
                  //     addLaps();
                  //   },
                  //   icon: const Icon(Icons.flag),
                  // ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {
                        addLaps(); //addLaps function is called
                        _scrollController.animateTo(
                          //this whole "animateTo" enum is used to move the current focus-position to the specified position, with some animation
                          _scrollController.position
                              .maxScrollExtent, //this means that move the position to the maximum extent of the scrollView
                          curve: Curves.ease, //this is to animate smoothly
                          duration: const Duration(
                              milliseconds:
                                  500), //this is to add some delay in the animation
                        );
                      },
                      onLongPress: () {
                        setState(() {
                          laps.clear(); //the 'laps' list is cleared, when the flag-btn is long-pressed
                        });
                      },
                      child: Ink(
                        color: Colors.transparent,
                        child: const Icon(
                          Icons.flag,
                          color: Colors.white,
                          size: 37,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 8,
                  ),

                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () {
                        resetTimer(); //called the "resetTimer" function to reset all the values
                      },
                      fillColor: Colors.blue,
                      shape: const StadiumBorder(
                        side: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      child: const Text(
                        'Reset',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
