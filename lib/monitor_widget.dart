import 'package:flutter/material.dart';
import 'package:flutter_repomgr/moor_db.dart';
import 'package:provider/provider.dart';

class MonitorWidget extends StatelessWidget {
  PessoaDao dao;

  MonitorWidget();

  @override
  Widget build(BuildContext context) {
    dao = Provider.of<PessoaDao>(context);
    return Container(
      color: Colors.blueGrey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildStat(context),
          ],
        ),
      ),
    );
  }

  StreamBuilder<List<Pessoa>> _buildStat(BuildContext context) {
    final dao = Provider.of<PessoaDao>(context);
    return StreamBuilder(
      stream: dao.watchAllPersons(),
      builder: (context, AsyncSnapshot<List<Pessoa>> snapshot) {
        if (snapshot.hasData) {
          final p = snapshot.data;
          return Text(p.length.toString(), style: TextStyle(color: Colors.white),);
        } else {
          return Text('Nada', style: TextStyle(color: Colors.white));
        }
      },
    );
  }
}
