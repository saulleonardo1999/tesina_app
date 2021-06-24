import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tesina/src/models/caseModel.dart';
import 'package:tesina/src/provider/caseProvider.dart';
import 'package:tesina/src/ui/cases/caseCard.dart';
import 'package:tesina/src/ui/widgets/menu.dart';
import 'package:tesina/src/ui/widgets/noContentMessage.dart';

class LostPetsPage extends StatefulWidget {
  @override
  _LostPetsPageState createState() => _LostPetsPageState();
}

class _LostPetsPageState extends State<LostPetsPage> {
  List<CaseModel> myCases = [];
  bool loading;
  @override
  void initState() {
    loading = true;
    CaseProvider().getCases().then((value){
      myCases = value;
      loading = false;
      setState(() {});
    });
    super.initState();
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
        myCases.isNotEmpty ?
        ListView.builder(
            itemCount: myCases.length,
            itemBuilder: (context, index){
              return
              CaseCard(
                myCase: myCases[index],
              );
            }
        ): NoContentMessage(message: "No hay registros de Eventos",)
    );
  }
  @override
  void dispose() {
    super.dispose();
  }
}
