import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class GeneratePDF extends StatefulWidget {
  final Map<dynamic, dynamic>? map;
  const GeneratePDF({Key? key, required this.map}) : super(key: key);

  @override
  State<GeneratePDF> createState() => _GeneratePDFState();
}

class _GeneratePDFState extends State<GeneratePDF> {
  String title = 'Application';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: PdfPreview(
        build: (format) => _generatePdf(format, title, widget.map!),
      ),
    );
  }

  Future<Uint8List> _generatePdf(
      PdfPageFormat format, String title, Map map) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.nunitoExtraLight();
    final image = await imageFromAssetBundle('assets/images/logo.png');
    final provider = await flutterImageProvider(NetworkImage(map['Image']));
    pdf.addPage(
      pw.Page(
        pageTheme: const pw.PageTheme(margin: pw.EdgeInsets.all(40)),
        //pageFormat: format,
        build: (context) {
          return pw.SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.SizedBox(
                    height: 80,
                    child: pw.Image(image),
                  ),
                  pw.SizedBox(
                    width: 300,
                    child: pw.FittedBox(
                      child: pw.Text('NCC Member Recruitment Form',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          )),
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.SizedBox(
                            width: 380,
                            child: pw.Column(
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.SizedBox(
                                    width: 380,
                                    child: pw.RichText(
                                        text: pw.TextSpan(children: [
                                      pw.TextSpan(
                                          text: 'Name : ',
                                          style: pw.TextStyle(
                                              fontSize: 15,
                                              fontWeight: pw.FontWeight.bold)),
                                      pw.TextSpan(
                                          text: map['name'],
                                          style:
                                              const pw.TextStyle(fontSize: 15))
                                    ])),
                                  ),
                                  pw.SizedBox(height: 5),
                                  pw.SizedBox(
                                    width: 380,
                                    child: pw.RichText(
                                        text: pw.TextSpan(children: [
                                      pw.TextSpan(
                                          text: 'ID : ',
                                          style: pw.TextStyle(
                                              fontSize: 15,
                                              fontWeight: pw.FontWeight.bold)),
                                      pw.TextSpan(
                                          text: map['id'],
                                          style:
                                              const pw.TextStyle(fontSize: 15))
                                    ])),
                                  ),
                                  pw.SizedBox(height: 5),
                                  pw.SizedBox(
                                    width: 380,
                                    child: pw.RichText(
                                        text: pw.TextSpan(children: [
                                      pw.TextSpan(
                                          text: 'Section : ',
                                          style: pw.TextStyle(
                                              fontSize: 15,
                                              fontWeight: pw.FontWeight.bold)),
                                      pw.TextSpan(
                                          text: map['section'],
                                          style:
                                              const pw.TextStyle(fontSize: 15))
                                    ])),
                                  ),
                                  pw.SizedBox(height: 5),
                                  pw.SizedBox(
                                    width: 380,
                                    child: pw.RichText(
                                        text: pw.TextSpan(children: [
                                      pw.TextSpan(
                                          text: 'Department : ',
                                          style: pw.TextStyle(
                                              fontSize: 15,
                                              fontWeight: pw.FontWeight.bold)),
                                      pw.TextSpan(
                                          text: map['dept'],
                                          style:
                                              const pw.TextStyle(fontSize: 15))
                                    ])),
                                  ),
                                  pw.SizedBox(height: 15),
                                  pw.SizedBox(
                                    width: 380,
                                    child: pw.RichText(
                                        text: pw.TextSpan(children: [
                                      pw.TextSpan(
                                          text: 'Apply for : ',
                                          style: pw.TextStyle(
                                              fontSize: 15,
                                              fontWeight: pw.FontWeight.bold)),
                                      pw.TextSpan(
                                          text: map['segment'],
                                          style:
                                              const pw.TextStyle(fontSize: 15))
                                    ])),
                                  )
                                ])),
                        pw.Column(children: [
                          pw.Container(
                            padding: const pw.EdgeInsets.all(5),
                              decoration:
                                  pw.BoxDecoration(border: pw.Border.all()),
                              child: pw.SizedBox(
                                width: 150,
                                height: 150,
                                child: pw.Image(provider,fit: pw.BoxFit.cover),
                              )),
                          pw.SizedBox(height: 5),
                          pw.RichText(
                              text: pw.TextSpan(children: [
                            pw.TextSpan(
                              text: 'Date: ',
                              style: pw.TextStyle(font: font)
                            ),
                            pw.TextSpan(
                              text: map['date'],
                                style: pw.TextStyle(font: font)
                            )
                          ])),
                        ])
                      ]),
                  pw.SizedBox(height: 5),
                  pw.Center(child: pw.Text("Applicant Detail's",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 20),)),
                  pw.SizedBox(height: 10),
                  pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        children: [
                          pw.RichText(
                              text: pw.TextSpan(
                                  children: [
                                    pw.TextSpan(
                                        text:
                                        'Age: ',
                                        style: pw.TextStyle(fontSize: 15,
                                            fontWeight: pw.FontWeight.bold)),
                                    pw.TextSpan(
                                        text: map[
                                        'age'],
                                        style: const pw.TextStyle(fontSize: 15))
                                  ])),
                          pw.SizedBox(width: 100),
                          pw.RichText(
                              text: pw.TextSpan(
                                  children: [
                                    pw.TextSpan(
                                        text:
                                        'Gender: ',
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,fontSize: 15)),
                                    pw.TextSpan(
                                        text: map['gender'],
                                        style: const pw.TextStyle(fontSize: 15))
                                  ])),
                        ],
                      ),
                      pw.SizedBox(height: 5),
                      pw.RichText(
                          text: pw.TextSpan(
                              children: [
                                pw.TextSpan(
                                    text:
                                    'E-Mail: ',
                                    style: pw.TextStyle(fontSize: 15,
                                        fontWeight: pw.FontWeight.bold)),
                                pw.TextSpan(
                                    text: map[
                                    'mail'],
                                    style: const pw.TextStyle(fontSize: 15))
                              ])),
                      pw.SizedBox(height: 5),
                      pw.RichText(
                          text: pw.TextSpan(
                              children: [
                                pw.TextSpan(
                                    text:
                                    'Mobile No: ',
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,fontSize: 15)),
                                pw.TextSpan(
                                    text: '+88${map['number']}',
                                    style: const pw.TextStyle(fontSize: 15))
                              ])),
                      pw.SizedBox(height: 5),
                      pw.RichText(
                          text: pw.TextSpan(
                              children: [
                                pw.TextSpan(
                                    text:
                                    'Address: ',
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,fontSize: 15)),
                                pw.TextSpan(
                                    text: map['address'],
                                    style: const pw.TextStyle(fontSize: 15))
                              ])),
                    ]
                  ),
                  pw.SizedBox(height: 5),
                  pw.Divider(),
                  pw.SizedBox(height: 5),
                  pw.RichText(
                      text: pw.TextSpan(
                          children: [
                            pw.TextSpan(
                                text:
                                "About Applicant's: ",
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,fontSize: 15)),
                            pw.TextSpan(
                                text: map['about'],
                                style: const pw.TextStyle(
                                    fontSize: 15))
                          ])),
                  pw.SizedBox(height: 5),
                  pw.Divider(),
                  pw.SizedBox(height: 5),
                  pw.RichText(
                      text: pw.TextSpan(
                          children: [
                            pw.TextSpan(
                                text:
                                'Reason for joining NCC : ',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,fontSize: 15)),
                            pw.TextSpan(
                                text: map['reason'],
                                style: const pw.TextStyle(fontSize: 15))
                          ])),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                    children: [
                      pw.SizedBox(
                        height: 130,
                        width: 130,
                        child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Divider(),
                            pw.Text("Applicant's Signature",style: const pw.TextStyle(fontSize: 10),)
                          ],
                        ),
                      ),
                      pw.SizedBox(
                        height: 130,
                        width: 130,
                        child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Divider(),
                            pw.Text("Executive's Signature",style: const pw.TextStyle(fontSize: 10),)
                          ],
                        ),
                      )
                    ],
                  ),
                  pw.SizedBox(height: 30),
                  pw.Center(child: pw.Text("This is an auto-generated application by NCC",style: const pw.TextStyle(fontSize: 10),))
                ],
              ));
        },
      ),
    );

    return pdf.save();
  }
}
