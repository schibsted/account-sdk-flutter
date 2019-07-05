import 'package:flutter/material.dart';
import 'package:schibsted_account_sdk/schibsted_account.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Schibsted Account plugin example'),
        ),
        body: StreamBuilder(
            initialData: SchibstedAccountEvent(SchibstedAccountState.unknown),
            stream: SchibstedAccountPlugin.loginEvents,
            builder: (context, snapshot) {
              var isLoggedIn = snapshot.hasData && (snapshot.data as SchibstedAccountEvent).schibstedAccountState == SchibstedAccountState.logged_in;
              return buildBody(context, isLoggedIn, snapshot);
            }),
      ),
    );
  }

  Widget buildBody(BuildContext context, bool isLoggedIn, AsyncSnapshot snapshot) {
    return Center(
      child: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: isLoggedIn
                ? null
                : () {
                    SchibstedAccountPlugin.login;
                  },
            child: Text('Log In'),
          ),
          RaisedButton(
              onPressed: !isLoggedIn
                  ? null
                  : () {
                      SchibstedAccountPlugin.logout;
                    },
              child: Text('Log Out')),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _schibstedAccountEventToWidget(context, snapshot),
          ),
        ],
      ),
    );
  }

  Widget _schibstedAccountEventToWidget(BuildContext context, AsyncSnapshot snapshot) {
    String text;
    if (snapshot.hasError)
      text = "Error! ${snapshot.error.toString()}";
    else if (snapshot.data == null)
      text = "Data is null!";
    else if (snapshot.hasData) {
      var event = snapshot.data as SchibstedAccountEvent;
      switch (event.schibstedAccountState) {
        case SchibstedAccountState.logged_in:
          text = event.schibstedAccountState.toString().split('.')[1] + " as " + event.schibstedAccountUserData.displayName;
          break;
        case SchibstedAccountState.logged_out:
        case SchibstedAccountState.unknown:
        case SchibstedAccountState.canceled:
        case SchibstedAccountState.fetching:
          text = event.schibstedAccountState.toString().split('.')[1];
          break;
        case SchibstedAccountState.error:
          text = event.schibstedAccountState.toString().split('.')[1] + ":" + event.schibstedAccountError.toString();
          break;
      }
    }
    return Text(
      text,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.title,
    );
  }
}
