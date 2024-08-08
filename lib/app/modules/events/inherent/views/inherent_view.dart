import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/inherent_controller.dart';

class InherentView extends GetView<InherentController> {
  const InherentView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InherentView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'InherentView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
