import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../../main.dart';

class CornDiseaseInfoScreen extends StatefulWidget {
  final String prediction;

  const CornDiseaseInfoScreen(this.prediction, {Key? key});

  @override
  _CornDiseaseInfoScreenState createState() => _CornDiseaseInfoScreenState();
}

class _CornDiseaseInfoScreenState extends State<CornDiseaseInfoScreen> {
  bool isLoading = true;
  late String cornDiseasePhotoUrl;
  late String diseaseName;
  late String aboutInfo;
  late String symptoms;
  late List<String> preventionAndControl;
  late String climaticRequirements;
  late String soil;
  late String landPreparation;
  late String irrigation;
  late String harvesting;
  late List<String> chemicalControl;
  late List<String> timeOfSowing;


  @override
  void initState() {
    super.initState();
    getDiseaseData(widget.prediction);
    // Add any additional logic you need here, like checking if the disease is saved to the user's collection.
  }

  Future<void> getDiseaseData(String prediction) async {
    var db = await mongo.Db.create("mongodb+srv://admin:admin1234@together.cvq6ffb.mongodb.net/plantinfo?retryWrites=true&w=majority");
    await db.open();

    var collection = await db.collection("Corn");
    var diseaseData =
    await collection.findOne(mongo.where.eq("disease_name", prediction));
    db.close();

    if (diseaseData != null) {
      setState(() {
        cornDiseasePhotoUrl = diseaseData['plant_photo_url'] as String;
        diseaseName = diseaseData['disease_name'] as String;
        aboutInfo = diseaseData['about_info'] as String;
        symptoms = diseaseData['symptoms'] as String;
        preventionAndControl =
            diseaseData['prevention_and_control']?.cast<String>() ?? [];
        climaticRequirements = diseaseData['climatic_requirements'] as String;
        soil = diseaseData['soil'] as String;
        landPreparation = diseaseData['land_preparation'] as String;
        irrigation = diseaseData['irrigation'] as String;
        harvesting = diseaseData['harvesting'] as String;
        chemicalControl = diseaseData['chemical_control']?.cast<String>() ?? [];
        timeOfSowing = diseaseData['time_of_sowing']?.cast<String>() ?? [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          // App bar configuration
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Corn Disease Photo
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                ),
                child: Image.network(
                  cornDiseasePhotoUrl, // Replace with the appropriate field for corn disease photo URL
                  width: 396,
                  height: 210,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Corn Disease Name
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(0, 0),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(
                              top: 10,
                              bottom: 10,
                            ),
                            child: Text(
                              diseaseName, // Replace with the appropriate field for corn disease name
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFF19311C),
                                fontSize: 25,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'About',
                          style:
                          TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    // Corn Disease Information
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                            child: Text(
                              aboutInfo, // Replace with the appropriate field for corn disease about info
                              textAlign: TextAlign.justify,
                              style: const TextStyle(fontSize: 16, fontFamily: 'Poppins',fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Symptoms
                    if (symptoms.isNotEmpty)
                      _buildInfo("Symptoms", symptoms),

                    // Prevention and Control
                    _buildSection("Prevention and Control", preventionAndControl),

                    // Climatic Requirements
                    _buildInfo("Climatic Requirements", climaticRequirements),

                    // Soil
                    _buildInfo("Soil", soil),

                    // Land Preparation
                    _buildInfo("Land Preparation", landPreparation),

                    // Irrigation
                    _buildInfo("Irrigation", irrigation),

                    // Harvesting
                    _buildInfo("Harvesting", harvesting),

                    // Chemical Control
                    if (chemicalControl.isNotEmpty)
                      _buildSection("Chemical Control", chemicalControl),

                    // Time of Sowing
                    if (timeOfSowing.isNotEmpty)
                      _buildSection("Time of Sowing", timeOfSowing),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
Widget _buildSection(String title, List<String> items) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      Column(
        children: items.map((item) => _buildInfoItem(item)).toList(),
      ),
    ],
  );
}

Widget _buildInfo(String title, String content) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      _buildInfoItem(content),
    ],
  );
}

Widget _buildInfoItem(String content) {
  return Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
    child: Text(
      content,
      textAlign: TextAlign.justify,
      style: const TextStyle(
        fontSize: 16,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
