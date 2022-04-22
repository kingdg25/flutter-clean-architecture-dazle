import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../domain/usecases/connection/get_user_info_usecase.dart';

class AgentProfilePresenter extends Presenter {
  Function? getUserInfoOnNext;
  Function? getUserInfoOnComplete;
  Function? getUserInfoOnError;

  GetUserInfoUseCase getUserInfoUseCase;

  AgentProfilePresenter(userRepository)
      : getUserInfoUseCase = GetUserInfoUseCase(userRepository);

  @override
  void dispose() {
    getUserInfoUseCase.dispose();
  }

  getUserInfo(String uid) {
    getUserInfoUseCase.execute(
        _GetUserInfoUseCaseObserver(this), GetUserInfoUseCaseParams(uid));
  }
}

class _GetUserInfoUseCaseObserver extends Observer<GetUserInfoUseCaseResponse> {
  final AgentProfilePresenter agentProfilePresenter;

  _GetUserInfoUseCaseObserver(this.agentProfilePresenter);
  @override
  void onComplete() {
    agentProfilePresenter.getUserInfoOnComplete!();
  }

  @override
  void onError(e) {
    agentProfilePresenter.getUserInfoOnError!(e);
  }

  @override
  void onNext(GetUserInfoUseCaseResponse? response) {
    agentProfilePresenter.getUserInfoOnNext!(response?.user);
  }
}
