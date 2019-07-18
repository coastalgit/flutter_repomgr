import 'package:flutter/material.dart';
import 'package:flutter_repomgr/greeting_manager.dart';
import 'package:flutter_repomgr/list_page.dart';
import 'package:provider/provider.dart';

import 'package:flutter_repomgr/helper.dart';
import 'package:flutter_repomgr/moor_db.dart';
import 'package:flutter_repomgr/person_manager.dart';
import 'package:flutter_repomgr/person_model.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      builder: (_) => AppDB().pessoaDao,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Disk Repo Manager'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GreetingManager _greetingMgr = GreetingManager(greetingMessage: '');
  PersonManager _personMgr = PersonManager(person: Person(name: '', age: 0));
  Future<Person> _person;

  @override
  void initState() {
    super.initState();
    print('initState');


    _greetingMgr.loadMessage();
    _person = _personMgr.loadPerson();
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                MaterialButton(
                  //shape: CircleBorder(side: BorderSide(width: 3, color: Colors.blueGrey)),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(width: 2, color: Colors.red),
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  child: Text('Delete all from disk'),
                  onPressed: _deleteAll,
                ),
                MaterialButton(
                  //shape: CircleBorder(side: BorderSide(width: 3, color: Colors.blueGrey)),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(width: 2, color: Colors.green),
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  child: Text('Load all from disk'),
                  onPressed: _loadAll,
                ),
              ],
            ),
            SizedBox(height: 10),
            FutureBuilder(
              //initialData: Person(name: 'XXX', age: 1),
              future: _person,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return const Text('Press load button');
                  case ConnectionState.waiting:
                    return const Text('Awaiting result...');
                  default:
                    if (snapshot.hasError)
                      //return new Text('Error: ${snapshot.error}');
                      return new Text('Error');
                    if (snapshot.hasData){
                      Person p = snapshot.data;
                      return Helpers.isNullOrEmpty(p.name)? Text('No body here'):Text((Helpers.isNullOrEmpty(_greetingMgr.greetingMessage)?'...':_greetingMgr.greetingMessage)+' '+p.name+' aged '+p.age.toString());
                    }
                    return new Text('No data');
                }
/*
                if (snapshot.hasError) {
                  return Text('Error');
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    Person p = snapshot.data;
                    return Text(
                        greetingMgr.greetingMessage + ' ' + p.name + ' (' + p.age.toString() + ')');
                  } else {
                    return Text('No data');
                  }
                } else {
                  return Text('Waiting...');
                }
*/
              },
            ),

/*
            Helpers.isNullOrEmpty(_personMgr.person.name)
                ? Text('No data')
                : Text(
                    _greetingMgr.greetingMessage +
                        ' ' +
                        _personMgr.person.name +
                        ' (' +
                        _personMgr.person.age.toString() +
                        ')',
                  ),
*/
            SizedBox(height: 10),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1), borderRadius: BorderRadius.all(Radius.circular(4))),
              child: Text('Enter your greeting'),
              onPressed: _doGreetingEntry,
            ),
            SizedBox(height: 10),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1), borderRadius: BorderRadius.all(Radius.circular(4))),
              child: Text('Enter your details'),
              onPressed: _doPersonEntry,
            ),
            SizedBox(height: 20),
            MaterialButton(
              //shape: CircleBorder(side: BorderSide(width: 3, color: Colors.blueGrey)),
              shape: RoundedRectangleBorder(
                  side: BorderSide(width: 2, color: Colors.blueGrey),
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              child: Text('DB Test Page'),
              onPressed: _loadDBTestPage,
            ),

          ],
        ),
      ),
    );
  }

  void _loadAll() {
    setState(() {
      _greetingMgr.loadMessage();
      _person = _personMgr.loadPerson();
    });
  }

  void _deleteAll() {
    setState(() {
      _greetingMgr.deleteData();
      _personMgr.deleteData();
      _person = _personMgr.loadPerson();
    });
  }

  void _doGreetingEntry() async {
    final String greeting = await _showDialogGreetingEntry(context);
    if (!Helpers.isNullOrEmpty(greeting)) {
      setState(() {
        _greetingMgr.greetingMessage = greeting;
        _greetingMgr.saveMessage();
      });
    }
  }

  void _doPersonEntry() async {
    final Person _person = await _showDialogPersonEntry(context);
    if (_person != null) {
      setState(() {
        _personMgr.person = _person;
        _personMgr.savePerson();
      });
    }
  }

  Future<Person> _showDialogPersonEntry(BuildContext context) async {
    Person _person = Person();

    return showDialog<Person>(
      context: context,
      barrierDismissible: false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Person'),
          content: new Column(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                autofocus: true,
                maxLength: 16,
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(labelText: 'Name'),
                onChanged: (value) {
                  _person.name = value;
                },
              )),
              new Expanded(
                  child: new TextField(
                autofocus: false,
                maxLength: 3,
                keyboardType: TextInputType.number,
                decoration: new InputDecoration(labelText: 'Age'),
                onChanged: (value) {
                  _person.age = int.parse(value);
                },
              ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop(_person);
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> _showDialogGreetingEntry(BuildContext context) async {
    String _greeting = '';

    return showDialog<String>(
      context: context,
      barrierDismissible: false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Greeting'),
          content: new Column(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                autofocus: true,
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(labelText: 'Message'),
                onChanged: (value) {
                  _greeting = value;
                },
              )),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop(_greeting);
              },
            ),
          ],
        );
      },
    );
  }

  void _loadDBTestPage() {

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return ListPage();
          },
        ),
      );


  }
}
