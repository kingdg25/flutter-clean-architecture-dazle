import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';

import '../../../domain/entities/property.dart';
import '../../../domain/entities/user.dart';
import 'agent_profile_presenter.dart';

class AgentProfileController extends Controller {
  final AgentProfilePresenter agentProfilePresenter;
  User? _agent;
  User? get agent => _agent;
  List<Property>? _agentListings;
  List<Property>? get agentListings => _agentListings;

  AgentProfileController(agentRepo)
      : agentProfilePresenter = AgentProfilePresenter(agentRepo);

  @override
  void initListeners() {
    agentProfilePresenter.getAgentInfoOnNext = (User agent) {
      if (_agent == null) {
        print("getting agent info(on next) ....");
        refreshUI();
      }
      _agent = agent;
    };

    agentProfilePresenter.getAgentInfoOnComplete = () {
      print("getting agent info(on complete) ....");
      // AppConstant.showLoader(getContext(), false);
    };

    agentProfilePresenter.getAgentInfoOnError = (e) {
      print("getting agent info(on error) ....");
    };
    // ================== AGENT LISTING ====================================
    agentProfilePresenter.getAgentListingOnNext = (List<Property>? listing) {
      print("getting agent listing(on next) ....");
      if (_agentListings == null) {
        refreshUI();
      }
      _agentListings = listing;
    };
    agentProfilePresenter.getAgentListingOnError = (e) {
      print("getting agent listing(ERROR=>) ...." + e);
    };
    agentProfilePresenter.getAgentListingOnComplete = () {
      print("getting agent listing(on complete) ....");
    };
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

  getAgentInfoAndListing({uid}) {
    agentProfilePresenter.getAgentInfo(uid);
    agentProfilePresenter.getAgentListing(uid);
  }
}
