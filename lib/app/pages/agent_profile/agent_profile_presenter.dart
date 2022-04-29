import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../domain/usecases/connection/get_agent_info_usecase.dart';
import '../../../domain/usecases/connection/get_agent_listing_usecase.dart';

class AgentProfilePresenter extends Presenter {
  Function? getAgentInfoOnNext;
  Function? getAgentInfoOnComplete;
  Function? getAgentInfoOnError;

  Function? getAgentListingOnNext;
  Function? getAgentListingOnComplete;
  Function? getAgentListingOnError;

  GetAgentInfoUseCase getAgentInfoUseCase;
  GetAgentListingUsecase getAgentListingUsecase;

  AgentProfilePresenter(agentRepository)
      : getAgentInfoUseCase = GetAgentInfoUseCase(agentRepository),
        getAgentListingUsecase = GetAgentListingUsecase(agentRepository);

  @override
  void dispose() {
    getAgentInfoUseCase.dispose();
    getAgentListingUsecase.dispose();
  }

  getAgentInfo(String uid) {
    getAgentInfoUseCase.execute(
        _GetAgentInfoUseCaseObserver(this), GetAgentInfoUseCaseParams(uid));
  }

  getAgentListing(String uid) {
    getAgentListingUsecase.execute(_GetAgentListingUsecaseObserver(this),
        GetAgentListingUsecaseParams(uid));
  }
}

class _GetAgentInfoUseCaseObserver
    extends Observer<GetAgentInfoUseCaseResponse> {
  final AgentProfilePresenter agentProfilePresenter;

  _GetAgentInfoUseCaseObserver(this.agentProfilePresenter);
  @override
  void onComplete() {
    agentProfilePresenter.getAgentInfoOnComplete!();
  }

  @override
  void onError(e) {
    agentProfilePresenter.getAgentInfoOnError!(e);
  }

  @override
  void onNext(GetAgentInfoUseCaseResponse? response) {
    agentProfilePresenter.getAgentInfoOnNext!(response?.agent);
  }
}

class _GetAgentListingUsecaseObserver
    extends Observer<GetAgentListingUsecaseResponse> {
  final AgentProfilePresenter agentProfilePresenter;

  _GetAgentListingUsecaseObserver(this.agentProfilePresenter);
  @override
  void onComplete() {
    agentProfilePresenter.getAgentListingOnComplete!();
  }

  @override
  void onError(e) {
    agentProfilePresenter.getAgentListingOnError!(e);
  }

  @override
  void onNext(GetAgentListingUsecaseResponse? response) {
    agentProfilePresenter.getAgentListingOnNext!(response?.property);
  }
}
