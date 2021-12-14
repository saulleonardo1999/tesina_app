import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tesina/src/models/caseModel.dart';
import 'package:tesina/src/provider/caseProvider.dart';
import 'package:tesina/src/ui/cases/caseCard.dart';
import 'package:tesina/src/ui/widgets/menu.dart';
import 'package:tesina/src/ui/widgets/noContentMessage.dart';

class EventsPage extends StatefulWidget {
  final int caseType;

  const EventsPage({Key key, this.caseType}) : super(key: key);
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  List<CaseModel> myCases;
  List<CaseModel> typeCases ;

  bool loading;
  @override
  void initState() {
    myCases = [];
    typeCases = [];
    loading = true;
    CaseProvider().getCases().then((value){
      myCases = value;
      assignTypeCases();
      loading = false;
      setState(() {});
    });
    super.initState();
  }
  void assignTypeCases(){
    myCases.forEach((element) {
      if(element.type == widget.caseType){
        typeCases.add(element);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
              "Informes de Eventos"
          ),
        ),
        drawer: MenuWidget(),
        body: loading ?
        Center(
          child: CircularProgressIndicator(
            valueColor:
            new AlwaysStoppedAnimation<Color>(Colors.blueGrey),
          ),
        ):
        typeCases.isEmpty?
        NoContentMessage(message: "No hay registros de Eventos",):
        ListView.builder(
            itemCount: typeCases.length,
            itemBuilder: (context, index){
              return CaseCard(
                myCase: typeCases[index],
              );
            }
        )
    );
  }
  @override
  void dispose() {
    super.dispose();
  }
}
