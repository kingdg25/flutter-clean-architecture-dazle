import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../data/repositories/data_connection_repository.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/profile/profile_info.dart';
import 'agent_profile_controller.dart';

class AgentProfilePage extends View {
  final String? uid;

  AgentProfilePage(this.uid);
  @override
  _AgentProfilePageState createState() => _AgentProfilePageState(uid);
}

class _AgentProfilePageState
    extends ViewState<AgentProfilePage, AgentProfileController> {
  String? uid;

  _AgentProfilePageState(this.uid)
      : super(AgentProfileController(DataConnectionRepository()));

  @override
  Widget get view => Scaffold(
        key: globalKey,
        appBar: CustomAppBar(
          title: 'AgentProfile',
        ),
        body: Container(
          child: ControlledWidgetBuilder<AgentProfileController>(
            builder: (context, controller) {
              controller.getUserInfo(uid: uid!);

              return Container(
                child:
                    SingleChildScrollView(child: ProfileInfo(controller.user!)),
              );
            },
          ),
        ),
      );
}
