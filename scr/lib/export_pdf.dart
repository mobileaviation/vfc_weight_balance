import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'Airplanes.dart';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

import 'WBData.dart';

class PdfExport {
  Document _pdf;

  void Generate(List<WBData> inputData, Airplane airplane, WBData zfwWB, WBData takeoffWB, WBData rampWB, ui.Image envelope) {
    this.airplane = airplane;
    this.inputData = inputData;
    this.takeoffWB = takeoffWB;
    this.zfwWB = zfwWB;
    this.rampWB = rampWB;


    _pdf = Document(title: "Weight & Balance: " + airplane.callsign,
        author: "Vliegclub Flevo",
        subject: airplane.callsign);

    _pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (Context context) => <Widget> [
        Container(child: Text("Weigth & Balance report", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)) ,
            alignment: Alignment.center,
            margin: const EdgeInsets.all(10)),
        Container(child: Text("Airplane: " + airplane.callsign) , alignment: Alignment.center, margin: const EdgeInsets.all(5)),
        Container(child: Text("Date Generated: " + _getDateFormated() ) , alignment: Alignment.center, margin: const EdgeInsets.all(5)),
        _buildTable(airplane)
      ],
    ));

    _getEnvelope(_pdf, envelope);
    _savePdftoFile();
  }

  Future _getEnvelope(Document pdf, ui.Image image) async {
    ByteData data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    Uint8List udata = await data.buffer.asUint8List();

    double x = (pdf.document.page(0).pageFormat.width/2) - (image.width/2);

    PdfImage pdfimage = PdfImage(
      pdf.document,
      width: image.width,
      height: image.height,
      image: udata,
    );

    final PdfGraphics g = pdf.document.page(0).getGraphics();

    g.drawImage(pdfimage, x, 50);
  }

  String _getDateFormated()
  {
    var now = new DateTime.now();
    var formatter = new DateFormat('dd MMMM yyyy');
    String formatted = formatter.format(now);
    return formatted;
  }

  List<WBData> inputData;
  Airplane airplane;
  WBData zfwWB;
  WBData takeoffWB;
  WBData rampWB;

  Table _buildTable(Airplane airplane) {
    return Table(
      children: _buildTableRows(airplane),
      border: const TableBorder(),
      tableWidth: TableWidth.max,
    );
  }

  List<TableRow> _buildTableRows(Airplane airplane)
  {
    final List<TableRow> rows = <TableRow>[];

    double front_lbs = inputData[0].weightLbs + inputData[1].weightLbs;
    double back_lbs = inputData[2].weightLbs + inputData[3].weightLbs;
    double bag_lbs = inputData[4].weightLbs;

    double front_lbsin = inputData[0].moment + inputData[1].moment;
    double back_lbsin = inputData[2].moment + inputData[3].moment;
    double bag_lbsin = inputData[4].moment;

    double zfw = airplane.bew + front_lbs + back_lbs + bag_lbs;
    double zfw_moment = airplane.beMoment + front_lbsin + back_lbsin + bag_lbsin;

    rows.add( _buildRow(<String>["Station", "lbs", "in", "in-lbs"], TableBorder(), true) );

    rows.add(_buildRow(<String>["BEW", _toStringClean(airplane.bew, 1.0),
        _toStringClean(airplane.beArm, 2.0),
        _toStringClean(airplane.beMoment, 2.0)],  TableBorder(), false));
    rows.add(_buildRow(<String>["Front", _toStringClean(front_lbs, 1.0),
      _toStringClean(airplane.frontArm, 2.0),
      _toStringClean(front_lbsin, 2.0)],  TableBorder(), false));
    rows.add(_buildRow(<String>["Rear", _toStringClean(back_lbs, 1.0),
      _toStringClean(airplane.rearArm, 2.0),
      _toStringClean(back_lbsin, 2.0)],  TableBorder(), false));
    rows.add(_buildRow(<String>["bagage", _toStringClean(bag_lbs, 1.0),
      _toStringClean(airplane.bagageArm, 2.0),
      _toStringClean(bag_lbsin, 2.0)],  TableBorder(), false));


    if (zfwWB!=null && takeoffWB!=null) {
      rows.add(_buildRow(<String>["ZFW", _toStringClean(zfwWB.weightLbs, 1.0),
          _toStringClean(zfwWB.arm, 2.0),
          _toStringClean(zfwWB.moment, 2.0)], TableBorder(), true));
  rows.add(_buildRow(<String>["Total fuel", _toStringClean(inputData[5].weightLbs, 1.0),
          _toStringClean(inputData[5].arm, 2.0),
          _toStringClean(inputData[5].moment, 2.0)], TableBorder(), false));
  rows.add(_buildRow(<String>["Ramp weight", _toStringClean(rampWB.weightLbs, 1.0),
          _toStringClean(rampWB.arm, 2.0),
          _toStringClean(rampWB.moment, 2.0)], TableBorder(width: 5), true));

  rows.add(_buildRow(<String>["Taxi fuel", _toStringClean(inputData[6].weightLbs, 1.0),
          _toStringClean(inputData[6].arm, 2.0),
          _toStringClean(inputData[6].moment, 2.0)], TableBorder(), false));

  rows.add(_buildRow(<String>["Takeoff weight", _toStringClean(takeoffWB.weightLbs, 1.0),
          _toStringClean(takeoffWB.arm, 2.0),
          _toStringClean(takeoffWB.moment, 2.0)], TableBorder(width: 5), true));
    }

    return rows;
  }

  TableRow _buildRow(List<String> values, TableBorder border, bool header)
  {
    final List<Widget> tablerow = <Widget>[];
    for (String cell in values) {
      tablerow.add(Container(
          color: (header) ? PdfColors.lightGreen : PdfColors.white,
          alignment: Alignment.center,
          margin: const EdgeInsets.all(5),
          child: Text(cell,
            style: TextStyle(fontWeight: (header) ? FontWeight.bold : FontWeight.normal)
          )
      ));
    }

    return TableRow(children: tablerow);
  }

  String _toStringClean(double value, double roundDepth)
  {
    if (value==0.0) return "";
    double roundFactor = pow(10.0, roundDepth);
    return ((value * roundFactor).round().toDouble() / roundFactor).toString();
  }

  Future _savePdftoFile()
  async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var file = File("$tempPath/file.pdf");
    await file.writeAsBytes(_pdf.save());
  }
}
