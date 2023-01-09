//before production

// ca-app-pub-1910071497933889~3564931879 for manifest
// ca-app-pub-1910071497933889/7705742461 for banner in code
//ca-app-pub-1910071497933889/5058030846  interstitialad


import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import 'package:pdfconvo/ads/banner_ad.dart';
import 'package:printing/printing.dart';
import 'package:tbib_splash_screen/splash_screen_view.dart';

class Firstpage extends StatefulWidget {
  @override
  _FirstpageState createState() => _FirstpageState();
}

class _FirstpageState extends State<Firstpage> {
  final picker = ImagePicker();
  final pdf = pw.Document();
  List<File> image = [];
  var pageformat = "A4";


  DateTime? currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Press again to exit.");
      return Future.value(false);
    }
    return Future.value(true);
  }
  //ads work
  InterstitialAd? interstitialAd;
  bool isLoaded = false;

  void loadInterstitial() {
    InterstitialAd.load(
      adUnitId: "ca-app-pub-1910071497933889/5058030846",
      // adUnitId: "ca-app-pub-3940256099942544/1033173712",
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          print("loadInterstitial | Ad Loaded");
          print(ad.responseInfo);

          setState(() {
            interstitialAd = ad;
            isLoaded = true;
          });
        },
        onAdFailedToLoad: (error) {
          print("Ad Failed to Load");
          print(error.responseInfo);
          print(error.message);

        },
      ),
    );
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    loadInterstitial();
  }


  //ads work closed

  @override
  void initState() {
    // Timer(
    //     Duration(seconds: 5),
    //         () => loadInterstitial());
    if(isLoaded){
      print("isLoaded AD called =========");
      interstitialAd!.show();

    }else{

      print("loadInterstitial AD called =========");
      loadInterstitial();

    }
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: WillPopScope(
          onWillPop: onWillPop,
          child: Stack(
            children: [
              image.length == 0
                  ? Column(
                    children: [
                      SizedBox(height: 15,),

                      CustomBannerAd(),
                      Spacer(),
                      Container(
                            // color: Colors.grey.withOpacity(0.2),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Lottie.asset("assets/animations/lottie.json"),
                            ),
                      ),
                      Spacer(),
                      Spacer(),
                    ],
                  )
                  : PdfPreview(
                maxPageWidth: 1000,
                canChangeOrientation: true,
                canDebug: false,
                build: (format) => generateDocument(
                  format,
                  image.length,
                  image,
                ),
              ),
              Align(
                alignment: Alignment(-0.5, 0.8),
                child: GestureDetector(
                  onTap: getImageFromGallery,

                  child: Card(
                    color: Colors.transparent,

                    elevation: 0,
                    child: Container(
                      height: 50,
                      width: 90,
                      child: Icon(Icons.image_outlined,color: Colors.white,),
                      decoration: BoxDecoration(
                        color: Color(0xFFB1C6FE),
                        // color: Colors.greenAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0.5, 0.8),
                child:  InkWell(
                  onTap: getImageFromCamera,
                  child: Card(
                    elevation: 0,
                    color: Colors.transparent,

                    child: Container(
                      height: 50,
                      width: 90,
                      child: Icon(Icons.camera_alt_outlined,color: Colors.white,),
                      decoration: BoxDecoration(
                        // color: Colors.red,
                        // color: Color(0xFFF7A971),
                        color: Color(0xFFFFB886),

                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getImageFromGallery() async {

    Fluttertoast.showToast(msg: "Opening Gallery");

    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    // PickedFile pickedFile  = await ImagePicker().getI
    setState(() {
      if (pickedFile != null) {
        image.add(File(pickedFile.path));
      } else {
        print('No image selected');
      }
    });
  }

  getImageFromCamera() async {
    Fluttertoast.showToast(msg: "Opening Camera");

    final pickedFile = await picker.getImage(source: ImageSource.camera);
    print("Function Called getImageFromCamera |  ${pickedFile.toString}");

    setState(() {
      if (pickedFile != null) {
        print(">>>>>>>>>> : Image Selected");
        image.add(File(pickedFile.path));
      } else {
        print('No image selected');
      }
    });
  }

  Future<Uint8List> generateDocument(
      PdfPageFormat format, imagelenght, image) async {
    final doc = pw.Document(pageMode: PdfPageMode.outlines);

    final font1 = await PdfGoogleFonts.openSansRegular();
    final font2 = await PdfGoogleFonts.openSansBold();

    for (var im in image) {
      final showimage = pw.MemoryImage(im.readAsBytesSync());

      doc.addPage(
        pw.Page(
          pageTheme: pw.PageTheme(
            pageFormat: format.copyWith(
              marginBottom: 0,
              marginLeft: 0,
              marginRight: 0,
              marginTop: 0,
            ),
            orientation: pw.PageOrientation.portrait,
            theme: pw.ThemeData.withFont(
              base: font1,
              bold: font2,
            ),
          ),
          build: (context) {
            return pw.Center(
              child: pw.Image(showimage, fit: pw.BoxFit.contain),
            );
          },
        ),
      );
    }

    return await doc.save();
  }
}