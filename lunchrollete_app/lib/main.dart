// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert' show json;

import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/services.dart';
import 'package:lunchrollete_app/model/Staff.dart';
import './viewModel/staff_cell.dart';

var _isLoading = true;

var _staffs = [
  new Staff(1, "Reza", "Farahani", "https://secure.meetupstatic.com/photos/member/5/4/e/9/highres_286521737.jpeg", 3),
  new Staff(1, "Jeroen", "Tietema", "https://secure.meetupstatic.com/photos/member/7/0/7/8/highres_45628792.jpeg", 2),
  new Staff(1, "Zara", "Dominguez", "https://secure.meetupstatic.com/photos/member/4/d/8/6/highres_254239846.jpeg", 4),
  new Staff(1, "Quirijn", "Groot Bluemink", "https://secure.meetupstatic.com/photos/member/7/4/e/2/highres_84869922.jpeg", 3),
  new Staff(1, "Brett", "Morgan", "https://secure.meetupstatic.com/photos/member/3/f/9/0/highres_11116272.jpeg", 5)
  ];

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

void main() {
  runApp(
    MaterialApp(
      title: 'Lunch Roulette Singin',
      home: SignInDemo(),
    ),
  );
}

class SignInDemo extends StatefulWidget {
  @override
  State createState() => SignInDemoState();
}

class SignInDemoState extends State<SignInDemo> {
  GoogleSignInAccount _currentUser;
  String _contactText;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _handleGetContact();
      }
    });
    _setUpGoogleSignIn();
  }

  void _setUpGoogleSignIn() async {
  try {
    //final account = await _googleSignIn.signInSilently(suppressErrors: false).catchError((dynamic e){ print('$e'); });
    final account = await _googleSignIn.signIn();
    print("Successfully signed in as ${account.displayName}.");
  } on PlatformException catch (e) {
    // User not signed in yet. Do something appropriate.
    print("The user is not signed in yet. Asking to sign in.");
    //_googleSignIn.signIn();
  }
}

  Future<void> _handleGetContact() async {
    setState(() {
      _contactText = "Loading contact info to Lunch Roulette";
    });
    final http.Response response = await http.get(
      'https://people.googleapis.com/v1/people/me/connections'
      '?requestMask.includeField=person.names',
      headers: await _currentUser.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = "People API gave a ${response.statusCode} "
            "response. Check logs for details.";
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data = json.decode(response.body);
    final String namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = "I see you know $namedContact!";
      } else {
        _contactText = "No contacts to display.";
      }
    });
  }

  String _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic> connections = data['connections'];
    final Map<String, dynamic> contact = connections?.firstWhere(
      (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    );
    if (contact != null) {
      final Map<String, dynamic> name = contact['names'].firstWhere(
        (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      );
      if (name != null) {
        return name['displayName'];
      }
    }
    return null;
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() async {
    _googleSignIn.disconnect();
  }

  Widget _buildBody() {
    if (_currentUser != null) {
    _isLoading = false;
      return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("Lunch Roulette"),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.refresh),
              onPressed: () {
                print("reloading...");
                setState(() {
                  _isLoading = false;
                });
                //_fetchData();
              },
            )
          ],
        ),
        body: new Center(
          child: _isLoading
              ? new CircularProgressIndicator()
              : new ListView.builder(
                  itemCount: this != null ? _staffs.length : 0,
                  itemBuilder: (context, i) {
                    final staff = _staffs[i];
                    return new FlatButton(
                      child: new StaffCell(staff),
                      padding: new EdgeInsets.all(0.0),
                      onPressed: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                // builder: (context) =>
                                //     new CourseDetailsPage(video)
                                    ));
                      },
                    );
                  },
                ),
        ),
      ),
    );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text("You are not currently signed in."),
          RaisedButton(
            child: const Text('SIGN IN'),
            onPressed: _handleSignIn,
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: const Text('Lunch Roulette'),
        // ),
        body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: !_isLoading ?  _buildBody() : new CircularProgressIndicator(),
        ));
  }
}