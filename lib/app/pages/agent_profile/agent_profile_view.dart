import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../data/repositories/data_connection_repository.dart';
import '../../utils/app.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/profile/profile_info.dart';
import 'agent_profile_controller.dart';

class AgentProfilePage extends View {
  final String? uid;
  final String? name;

  AgentProfilePage(this.uid, this.name);
  @override
  _AgentProfilePageState createState() => _AgentProfilePageState(uid, name);
}

class _AgentProfilePageState
    extends ViewState<AgentProfilePage, AgentProfileController> {
  String? uid;
  String? name;

  _AgentProfilePageState(this.uid, this.name)
      : super(AgentProfileController(DataConnectionRepository()));

  @override
  Widget get view => Scaffold(
        key: globalKey,
        appBar: CustomAppBar(
          title: name,
        ),
        body: Container(
          child: ControlledWidgetBuilder<AgentProfileController>(
            builder: (context, controller) {
              controller.getAgentInfo(uid: uid!);
              controller.getAgentListings(uid: uid);
              if (controller.agent == null ||
                  controller.agentListings == null) {
                return Center(
                    child: CircularProgressIndicator(
                  color: App.mainColor,
                ));
              }
              return Container(
                child: SingleChildScrollView(
                    child: ProfileInfo(
                        controller.agent!, controller.agentListings!)),
              );
            },
          ),
        ),
      );
}
