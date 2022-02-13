import 'dart:io';

import 'package:dazle/domain/usecases/profile/request_verification_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class VerifyProfilePresenter extends Presenter {
  Function? requestVerificationOnNext;
  Function? requestVerificationOnComplete;
  Function? requestVerificationOnError;

  final RequestVerificationUsecase requestVerificationUsecase;

  VerifyProfilePresenter(userRepo)
      : requestVerificationUsecase = RequestVerificationUsecase(userRepo);

  void requestVerification({File? attachment}) {
    requestVerificationUsecase.execute(
        _RequestVerificaitonUseCaseObserver(this),
        RequestVerificationUseCaseParams(attachment));
  }

  @override
  void dispose() {
    requestVerificationUsecase.dispose();
  }
}

class _RequestVerificaitonUseCaseObserver
    extends Observer<RequestVerificationUseCaseResponse> {
  final VerifyProfilePresenter presenter;
  _RequestVerificaitonUseCaseObserver(this.presenter);

  @override
  void onComplete() {
    assert(presenter.requestVerificationOnComplete != null);
    presenter.requestVerificationOnComplete!();
  }

  @override
  void onError(e) {
    assert(presenter.requestVerificationOnError != null);
    presenter.requestVerificationOnError!(e);
  }

  @override
  void onNext(response) {
    assert(presenter.requestVerificationOnNext != null);
    presenter.requestVerificationOnNext!(response!.verificaiton);
  }
}
