import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/inherent_detail_controller.dart';

class InherentDetailView extends GetView<InherentDetailController> {
  const InherentDetailView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InherentDetailView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'InherentDetailView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
