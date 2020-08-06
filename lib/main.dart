import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';
void main()
{
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  SpeechRecognition _speechRecognition;
  bool _isAvailable=false;
  bool _isListening=false;
  String resultText="";
  @override
  void initState(){
    super.initState();
    initSpeechRecognizer();
  }
  void initSpeechRecognizer(){
    _speechRecognition=SpeechRecognition();
    _speechRecognition.setAvailabilityHandler((bool result)=>setState(()=> _isAvailable=result));
    _speechRecognition.setRecognitionStartedHandler(()=>setState(()=>_isListening=true));
    _speechRecognition.setRecognitionResultHandler((String speech)=>setState(()=>resultText=speech));
    _speechRecognition.setRecognitionCompleteHandler(()=>setState(()=>_isListening=false));
    _speechRecognition.activate().then((value) => setState(()=>_isAvailable=value));
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "TextToSpeech",
      home: Scaffold(
        appBar: AppBar(
          title: Text("SpeechToText"),
          actions: <Widget>[
            IconButton(
              icon:Icon(Icons.info_outline),
              onPressed: () { },
            ),
          ],
          backgroundColor:Colors.blue[900],
        ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
             new Image(
            image: new AssetImage("assets/stt.jpg"),
            fit: BoxFit.fitHeight,
            colorBlendMode: BlendMode.darken,
          ),
           new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:<Widget>[
                  new Container(
                    height: 200,
                    width: 500,
                    margin: EdgeInsets.all(25.0),
                  child: Text(resultText,style: TextStyle(fontSize:30.0,fontWeight: FontWeight.bold,color: Colors.white70))
                
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:<Widget>[
                    FlatButton(
                      child: Icon(Icons.clear,color: Colors.white,),
                      onPressed:(){
                        if(_isListening)
                        _speechRecognition.cancel().then((value) => setState((){_isListening=value;
                        resultText=" ";}));
                        else
                        setState(() {
                          resultText=" ";
                        });
                      }
                    ),
                    FloatingActionButton(onPressed: (){
                      if(_isAvailable && !_isListening)
                      {
                      _speechRecognition
                      .listen(locale: "en_IN",)
                      .then((value) => print("$value")); 
                    }},
                    child: Icon(Icons.mic),
                    ),
                    FlatButton(
                      child: Icon(Icons.pause,color: Colors.white,),
                      onPressed:(){
                        if(_isListening)
                        _speechRecognition.stop().then((value) => setState(()=> _isListening= value));
                      } ,
                    )
                  ]
                ),
                  ]
                  ),
            ]
        ),
      )
    );
  }
}