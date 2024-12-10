import 'dart:async';
import 'package:flutter/material.dart';
void main(){
  runApp(myapp());
}
class myapp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: stopwatch(),
    );
  }
}
class stopwatch extends StatefulWidget{
  @override
  _stopwatchState createState()=> _stopwatchState();
}
class _stopwatchState extends State<stopwatch> {
  late Stopwatch _stopwatch;
  late Timer _timer;
  String _timeDisplay = "00:00:00";
  List<String> _laps = [];

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _timer = Timer.periodic(Duration(milliseconds: 100), (_timer) {
      if (_stopwatch.isRunning) {
        setState(() {
          _timeDisplay = _formatDuration(_stopwatch.elapsed);
        });
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  void _startStop() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
    }
    else {
      _stopwatch.start();
    }
    setState(() {});
  }

  void _reset() {
    _stopwatch.reset();
    _laps.clear();
    setState(() {
      _timeDisplay = "00:00:00";
    });
  }

  void _recordLap() {
    if (_stopwatch.isRunning) {
      setState(() {
        _laps.add(_timeDisplay);
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text('STOP WATCH'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Column(
              children: [
                Text(_timeDisplay,
                  style: TextStyle(fontSize: 48, color: Colors.white),),
                SizedBox(height: 16),
                ElevatedButton(onPressed: _recordLap, child: Text("LAP"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _laps.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    "LAP ${index + 1}: ${_laps[index]}",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),

          Padding(padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(icon: Icon(
                      _stopwatch.isRunning ? Icons.stop : Icons.play_arrow,
                      color: _stopwatch.isRunning?Colors.red:Colors.green,
                    ),
                      onPressed: _startStop,
                      iconSize: 50,
                    ),
                    SizedBox(width: 20),
                    IconButton(icon: Icon(Icons.replay, color: Colors.blue),
                      onPressed: _reset,
                      iconSize: 50,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}