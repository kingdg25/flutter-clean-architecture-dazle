

import 'package:dazle/data/repositories/data_authentication_repository.dart';
import 'package:dazle/domain/usecases/authentication/send_email_verification_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class EmailVerificationPresenter extends Presenter {
  final SendEmailVerificationUseCase sendEmailVerificationUserCase;
  Function? sendEmailVerificationOnComplete;
  Function? sendEmailVerificationOnError;

  EmailVerificationPresenter():
    sendEmailVerificationUserCase = SendEmailVerificationUseCase(DataAuthenticationRepository()),
    super();

  sendEmailVerification(){
    sendEmailVerificationUserCase.execute(_SendEmailVerificationUseCaseObserver(this));
  }

  @override
  void dispose() {
    sendEmailVerificationUserCase.dispose();
  }
}

class _SendEmailVerificationUseCaseObserver extends Observer<void> {
  final EmailVerificationPresenter presenter;
  _SendEmailVerificationUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.sendEmailVerificationOnComplete != null);
    presenter.sendEmailVerificationOnComplete!();
  }

  @override
  void onError(e) {
    assert(presenter.sendEmailVerificationOnError != null);
    presenter.sendEmailVerificationOnError!(e);
  }

  @override
  void onNext(response) {
  }
}