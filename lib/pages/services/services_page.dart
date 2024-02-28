import 'dart:ui';
import 'package:agriplant/data/services.dart';
import 'package:agriplant/models/service.dart';
import 'package:agriplant/pages/services/paddy_service_page.dart';
import 'package:flutter/material.dart';

import 'corn_service_page.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  void navigateToServicePage(BuildContext context, Service service) {
    switch (service.name) {
      case "Paddy Disease Detector":

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PaddyService(service: service)),
        );
        break;
      case "Corn Disease Detector":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CornService(service: service)),
        );
        break;
    // Add more cases if you have additional services
      default:
      // Handle default case or show an error
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade100,
        centerTitle: false,
        title: Text("Our services", style: Theme.of(context).textTheme.titleLarge),
      ),
      body: GridView.builder(
        itemCount: services.length,
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              navigateToServicePage(context, services[index]);
            },
            child: Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(services[index].image),
                  fit: BoxFit.cover,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Text(
                      services[index].name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
