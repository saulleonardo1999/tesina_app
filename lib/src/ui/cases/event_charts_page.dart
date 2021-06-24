import 'package:flutter/material.dart';
import 'package:tesina/src/ui/cases/charts/gauge_chart.dart';
import 'package:tesina/src/ui/cases/charts/simple_bar_chart.dart';
import 'package:tesina/src/ui/cases/charts/time_series_symbol_annotation_chart.dart';
import 'package:tesina/src/ui/widgets/menu.dart';

class EventChartsPage extends StatefulWidget {
  const EventChartsPage({Key key}) : super(key: key);

  @override
  _EventChartsPageState createState() => _EventChartsPageState();
}

class _EventChartsPageState extends State<EventChartsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
              "Gráficos de eventos"
          ),
        ),
        drawer: MenuWidget(),
        body:
        SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20,),
              Center(
                child: Text("Porcentaje de choques anualmente"),
              ),
              SizedBox(height: 40,),
              Container(
                width: MediaQuery.of(context).size.width*0.9,
                  height: MediaQuery.of(context).size.width*0.8,
                  child: SimpleBarChart.withSampleData()
              ),
              SizedBox(height: 40,),
              Center(
                child: Text("Aumento lineal de choques por fechas"),
              ),
              SizedBox(height: 40,),
              Container(
                  width: MediaQuery.of(context).size.width*0.9,
                  height: MediaQuery.of(context).size.width*0.8,
                  child: TimeSeriesSymbolAnnotationChart.withSampleData()
              ),
              SizedBox(height: 40,),
              Center(
                child: Text("Tráfico por zona"),
              ),
              SizedBox(height: 40,),
              Container(
                  width: MediaQuery.of(context).size.width*0.9,
                  height: MediaQuery.of(context).size.width*0.8,
                  child: GaugeChart.withSampleData()
              )
            ],
          ),
        )
    );
  }
}
