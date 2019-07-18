import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_repomgr/moor_db.dart';
import 'package:flutter_repomgr/person_model.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  bool _showOver18Only = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Moor DB'),
        actions: <Widget>[
          _buildOver18Switch(),
        ],
      ),
      body: _buildBody(),
    );
  }

  _buildOver18Switch() {
    return Row(
      children: <Widget>[
        Text('Over 18 only'),
        Switch(
          value: _showOver18Only,
          activeColor: Colors.white,
          onChanged: (newValue) {
            setState(() {
              _showOver18Only = newValue;
            });
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MaterialButton(
            shape:
                RoundedRectangleBorder(side: BorderSide(width: 1), borderRadius: BorderRadius.all(Radius.circular(4))),
            child: Text('Enter a person'),
            onPressed: _doPersonEntry,
          ),
        ),
        Expanded(child: _buildPersonsList(context)),
      ],
    );
  }

  StreamBuilder<List<Pessoa>> _buildPersonsList(BuildContext context) {
    final dao = Provider.of<PessoaDao>(context);
    return StreamBuilder(
      stream: _showOver18Only ? dao.watchAllPersonsOver18OrderedByAge() : dao.watchAllPersons(),
      builder: (context, AsyncSnapshot<List<Pessoa>> snapshot) {
        final peeps = snapshot.data ?? List();
        return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: peeps.length,
          itemBuilder: (_, index) {
            final peep = peeps[index];
            return _buildListItem(peep, dao);
          },
        );
      },
    );
  }

  void _doPersonEntry() async {
    final Person _person = await _showDialogPersonEntry(context);

    if (_person != null) {
      setState(() {
        //Pessoa pessoa = Pessoa.fromData(data, db)
        Pessoa pessoa = Pessoa(name: _person.name, age: _person.age);
        final dao = Provider.of<PessoaDao>(context);
        dao.insertPerson(pessoa);
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
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: new TextField(
                  autofocus: true,
                  maxLength: 16,
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(labelText: 'Name'),
                  onChanged: (value) {
                    _person.name = value;
                  },
                ),
              ),
              Expanded(
                child: new TextField(
                  autofocus: false,
                  maxLength: 3,
                  keyboardType: TextInputType.number,
                  decoration: new InputDecoration(labelText: 'Age'),
                  onChanged: (value) {
                    _person.age = int.parse(value);
                  },
                ),
              )
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

  Widget _buildListItem(Pessoa peep, PessoaDao dao) {
    // we pass DAO ref here, allowing us direct access to CRUD methods e.g. swipe to delete etc
    return ListTile(
      leading: Icon(Icons.person),
      title: Text(peep.name),
      trailing: Text(peep.age.toString()),
    );
  }
}
