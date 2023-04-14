import 'package:appwrite/appwrite.dart';

import '../constants.dart' as constants;

class Appwrite {
  static final Appwrite instance = Appwrite._instance();

  late final Client client;

  Appwrite._instance() {
    client = Client()
        .setEndpoint(constants.appwriteEndpoint)
        .setProject(constants.appwriteProjectId)
        .setSelfSigned(status: constants.appwriteSelfSigned);
  }
}
