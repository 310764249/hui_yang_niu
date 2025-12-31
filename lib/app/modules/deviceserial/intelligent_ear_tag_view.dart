import 'package:flutter/cupertino.dart';

import '../../network/httpsClient.dart';

class IntelligentEarTagView extends StatefulWidget {
  const IntelligentEarTagView({super.key});

  @override
  State<IntelligentEarTagView> createState() => _IntelligentEarTagViewState();
}

class _IntelligentEarTagViewState extends State<IntelligentEarTagView>
    with AutomaticKeepAliveClientMixin {
  HttpsClient httpsClient = HttpsClient();

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    var response = await httpsClient.get('/api/intelligenteartag');
    print(response.data);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const Placeholder();
  }

  @override
  bool get wantKeepAlive => true;
}
