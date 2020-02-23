import 'dart:convert';

import 'package:eniachub_mobile_v011/classes/CheckInAPI.dart';
import 'package:eniachub_mobile_v011/classes/CheckInStatusAPI.dart';
import 'package:eniachub_mobile_v011/classes/Entity.dart';
import 'package:flutter/material.dart';

class CheckIn extends StatefulWidget {
  final StoredProcBase spBase;

  CheckIn({this.spBase});

  @override
  _CheckInState createState() => _CheckInState();
}

class _CheckInState extends State<CheckIn> {
  String _checkInStatus = "undefined";
  CheckInAPI checkInAPI;
  CheckInStatusAPI checkInStatusAPI;

  Future<StoredProcResponseBase> _checkIn(bool inOut) async {
    checkInAPI.inOut = inOut;
    try {
      String body = await checkInAPI.getResponse();
      print('check in api repsonse: $body');
      return StoredProcResponseBase.fromJson(json.decode(body));
    } catch (ex) {
      throw ex;
    }
  }

  Future<void> _getCheckInStatus() async {
    try {
      String body = await checkInStatusAPI.getResponse();
      print('check in status api repsonse: $body');
      setState(() {
        _checkInStatus = json.decode(body)["Status"];
      });
    } catch (ex) {
      throw ex;
    }
  }

  void _showSnackBar(BuildContext context, StoredProcResponseBase response) {
    final snackBar = SnackBar(
      content: Text(response.errorMsg),
      backgroundColor: response.rc == 0 ? Colors.green : Colors.red,
    );

    // Find the Scaffold in the widget tree and use
    // it to show a SnackBar.
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    checkInAPI = CheckInAPI(widget.spBase);
    checkInStatusAPI = CheckInStatusAPI(widget.spBase);
    _getCheckInStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Current status:'),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _checkInStatus,
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('Check in'),
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: () async {
                    var checkIn = await _checkIn(true);
                    setState(() {
                      _checkInStatus = 'Checked in';
                    });

                   _showSnackBar(context, checkIn);
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('Check out'),
                  color: Colors.red,
                  textColor: Colors.white,
                  onPressed: () async {
                    var checkIn = await _checkIn(false);
                    setState(() {
                      _checkInStatus = 'Checked out';
                    });
                    _showSnackBar(context, checkIn);
                  },
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}