import 'package:dazle/app/pages/agent_profile/agent_profile_presenter.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';

import '../../../domain/entities/user.dart';
import '../../utils/app_constant.dart';

class AgentProfileController extends Controller {
  final AgentProfilePresenter agentProfilePresenter;
  User? _user;
  User? get user => _user;

  AgentProfileController(userRepo)
      : agentProfilePresenter = AgentProfilePresenter(userRepo);

  @override
  void initListeners() {
    agentProfilePresenter.getUserInfoOnNext = (User user) {
      _user = user;
    };

    agentProfilePresenter.getUserInfoOnComplete = () {};

    agentProfilePresenter.getUserInfoOnError = (e) {};
  }

  @override
  void onResumed() => print('AgentProfile On resumed');

  @override
  void onReassembled() => print('AgentProfile is about to be reassembled');

  @override
  void onDeactivated() => print('AgentProfile is about to be deactivated');

  @override
  void onDisposed() {
    agentProfilePresenter.dispose(); // don't forget to dispose of the presenter
    super.onDisposed();
    Loader.hide();
  }

  getUserInfo({String uid = ""}) {
    agentProfilePresenter.getUser(uid);
  }
}
