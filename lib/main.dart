import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomeApp(),
    );
  }
}

class MyHomeApp extends StatefulWidget {
  const MyHomeApp({Key? key}) : super(key: key);

  @override
  MyHomeAppState createState() => MyHomeAppState();
}

class MyHomeAppState extends State<MyHomeApp> {
  int seconds = 0, minutes = 0, hours = 0;
  String secondsDigit = "00", minutesDigit = "00", hoursDigit = "00";
  Timer? timer;
  bool started = false;

  List laps = [];

  //stop-timer function
  void stopTimer() {
    timer!.cancel();
    setState(() {
      started = false;
    });
  }

  //reset function
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

  //function to add laps
  void addLaps() {
    String lap = "$hoursDigit : $minutesDigit : $secondsDigit";
    setState(() {
      laps.add(lap);
    });
  }

  //start-timer function
  void startTimer() {
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

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C2757),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
              Center(
                child: Text(
                  '$hoursDigit:$minutesDigit:$secondsDigit',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 65,
                  ),
                ),
              ),
              Container(
                height: 400,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: const Color(0xFF323F68),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.builder(
                  itemCount: laps.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 25),
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
                  controller: _scrollController,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () {
                        (!started) ? startTimer() : stopTimer();
                      },
                      shape: const StadiumBorder(
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
                      onTap: () {
                        addLaps();
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          curve: Curves.ease,
                          duration: const Duration(milliseconds: 500),
                        );
                      },
                      onLongPress: () {
                        setState(() {
                          laps.clear();
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
                        resetTimer();
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
