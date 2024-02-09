import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../../main.dart';

class PaddyDiseaseInfoScreen extends StatefulWidget {
  final String prediction;

  const PaddyDiseaseInfoScreen(this.prediction, {Key? key});

  @override
  _PaddyDiseaseInfoScreenState createState() => _PaddyDiseaseInfoScreenState();
}

class _PaddyDiseaseInfoScreenState extends State<PaddyDiseaseInfoScreen> {
  bool isLoading = true;
  late String paddyDiseasePhotoUrl;
  late String diseaseName;
  late List<String> symptoms;
  late List<String> causes;
  late List<String> prevention;
  late List<String> treatmentChemical;
  late List<String> treatmentPreventive;


  @override
  void initState() {
    super.initState();
    getPaddyDiseaseData(widget.prediction);
    // Add any additional logic you need here, like checking if the disease is saved to the user's collection.
  }

  Future<void> getPaddyDiseaseData(String prediction) async {
    var db = await mongo.Db.create(
        "mongodb+srv://admin:admin1234@together.cvq6ffb.mongodb.net/plantinfo?retryWrites=true&w=majority");
    await db.open();

    var collection = await db.collection(
        "Paddy"); // Change collection name to "Paddy"
    var diseaseData =
    await collection.findOne(mongo.where.eq("disease_name", prediction));
    db.close();

    if (diseaseData != null) {
      setState(() {
        paddyDiseasePhotoUrl = diseaseData['plant_photo_url'] as String;
        diseaseName = diseaseData['disease_name'] as String;
        symptoms = diseaseData['symptoms']?.cast<String>() ?? [];
        causes = diseaseData['causes']?.cast<String>() ?? [];
        prevention = diseaseData['prevention']?.cast<String>() ?? [];
        treatmentChemical =
            diseaseData['treatment_chemical']?.cast<String>() ?? [];
        treatmentPreventive =
            diseaseData['treatment_preventive']?.cast<String>() ?? [];
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
                  paddyDiseasePhotoUrl,
                  // Replace with the appropriate field for corn disease photo URL
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
                              diseaseName,
                              // Replace with the appropriate field for corn disease name
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
                    // Symptoms
                    if (symptoms.isNotEmpty)
                      _buildSection("Symptoms", symptoms),
                    const SizedBox(height: 16,),
                    // Causes
                    _buildSection("Causes", causes),
                    const SizedBox(height: 16,),
                    // Prevention
                    _buildSection("Prevention", prevention),
                    const SizedBox(height: 16,),
                    // Treatment Chemical
                    if (treatmentPreventive.isNotEmpty)
                      _buildSection("Chemical Treatment", treatmentChemical),
                    const SizedBox(height: 16,),
                    // Treatment Preventive
                    if (treatmentPreventive.isNotEmpty)
                      _buildSection("Preventive Treatment", treatmentPreventive),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: TextAlign.start,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items.map((item) => _buildInfoItem(item)).toList(),
        ),
      ],
    );
  }

  Widget _buildInfoItem(String content) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              content,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
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
}