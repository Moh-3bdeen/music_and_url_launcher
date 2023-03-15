import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:piano/piano.dart';
import 'package:url_launcher/url_launcher.dart';

class AllMusicalInstruments extends StatefulWidget {
  const AllMusicalInstruments({Key? key}) : super(key: key);

  @override
  State<AllMusicalInstruments> createState() => _AllMusicalInstrumentsState();
}

class _AllMusicalInstrumentsState extends State<AllMusicalInstruments> {
  final _flutterMidi = FlutterMidi();

  String _value = 'assets/Yamaha-Grand-Lite-SF-v1.1.sf2';

  var guitar = "assets/Best of Guitars-4U-v1.0.sf2";
  var flute = "assets/Expressive Flute SSO-v1.2.sf2";
  var piano = "assets/Yamaha-Grand-Lite-SF-v1.1.sf2";

  void load(String asset) async {
    print('Loading File...');
    _flutterMidi.unmute();
    ByteData byte = await rootBundle.load(asset);

    _flutterMidi.prepare(sf2: byte, name: _value.replaceAll('assets/', ''));
  }

  @override
  void initState() {
    load(_value);
    super.initState();
  }

  void _play(int midi) {
    _flutterMidi.playMidiNote(midi: midi);
  }


  makingPhoneCall({required String phone}) async {
    var url = Uri.parse("tel:$phone");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 4),
          backgroundColor: Colors.red,
          content: Text(
            "Could not launch $url",
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
      throw 'Could not launch $url';
    }
  }


  sendEmail({required String email}) {
    launch('mailto:$email?subject=This is Subject Title&body=This is Body of Email');
  }


  openGoogle() async {
    const url = 'https://www.google.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 4),
          backgroundColor: Colors.red,
          content: Text(
            "Could not launch $url",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: PopupMenuButton(
          elevation: 20,
          offset: const Offset(40, 40),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            side: BorderSide(width: 1, color: Colors.black12),
          ),
          icon: const Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: ListTile(
                  onTap: () => makingPhoneCall(phone: "0599597469"),
                  title: const Text("Call me"),
                  leading: const Icon(
                    Icons.phone,
                    color: Colors.black,
                  ),
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  onTap: () => sendEmail(email: "abdeenmohammed2002@gmail.com"),
                  title: const Text("Send email"),
                  leading: const Icon(
                    Icons.mail,
                    color: Colors.black,
                  ),
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  onTap: () => openGoogle(),
                  title: const Text("Open google"),
                  leading: const Icon(
                    FontAwesomeIcons.google,
                    color: Colors.black,
                  ),
                ),
              ),
            ];
          },
        ),
        actions: [
          DropdownButton<String>(
            style: const TextStyle(color: Colors.white),
            dropdownColor: Colors.blue,
            value: _value,
            items: [
              DropdownMenuItem(
                value: piano,
                child: const Text("Piano", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
              ),
              DropdownMenuItem(
                value: flute,
                child: const Text("Flute", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
              ),
              DropdownMenuItem(
                value: guitar,
                child: const Text("Guitar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _value = value!;
                load(_value);
              });
            },
          ),
        ],
      ),
      body: CupertinoApp(
        debugShowCheckedModeBanner: false,
        title: 'Musical Instruments',
        home: Center(
          child: InteractivePiano(
            highlightedNotes: [NotePosition(note: Note.C, octave: 3)],
            naturalColor: Colors.white,
            accidentalColor: Colors.black,
            keyWidth: 50,
            noteRange: NoteRange.forClefs([
              Clef.Treble,
            ]),
            onNotePositionTapped: (position) {
              _play(position.pitch);
            },
          ),
        ),
      ),
    );
  }
}
