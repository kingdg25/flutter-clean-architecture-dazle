import 'package:dazle/domain/usecases/authentication/forgot_password_usecase.dart';
import 'package:dazle/domain/usecases/authentication/reset_password_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class ForgotPasswordPresenter extends Presenter {
  Function forgotPasswordOnNext;
  Function forgotPasswordOnComplete;
  Function forgotPasswordOnError;

  Function resetPasswordOnNext;
  Function resetPasswordOnComplete;
  Function resetPasswordOnError;

  final ForgotPasswordUseCase forgotPasswordUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

  ForgotPasswordPresenter(userRepo)
    : forgotPasswordUseCase = ForgotPasswordUseCase(userRepo),
      resetPasswordUseCase = ResetPasswordUseCase(userRepo);
  
  void forgotPassword(String email) {
    forgotPasswordUseCase.execute(_ForgotPasswordUseCaseObserver(this), ForgotPasswordUseCaseParams(email));
  }

  void resetPassword(String email, String code, String password) {
    resetPasswordUseCase.execute(_ResetPasswordUseCaseObserver(this), ResetPasswordUseCaseParams(email, code, password));
  }

  @override
  void dispose() {
    forgotPasswordUseCase.dispose();
    resetPasswordUseCase.dispose();
  }
  
}



class _ForgotPasswordUseCaseObserver extends Observer<ForgotPasswordUseCaseResponse> {
  final ForgotPasswordPresenter presenter;
  _ForgotPasswordUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.forgotPasswordOnComplete != null);
    presenter.forgotPasswordOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.forgotPasswordOnError != null);
    presenter.forgotPasswordOnError(e);
  }

  @override
  void onNext(response) {
    assert(presenter.forgotPasswordOnNext != null);
    presenter.forgotPasswordOnNext(response.code);
  }
}



class _ResetPasswordUseCaseObserver extends Observer<ResetPasswordUseCaseResponse> {
  final ForgotPasswordPresenter presenter;
  _ResetPasswordUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.resetPasswordOnComplete != null);
    presenter.resetPasswordOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.resetPasswordOnError != null);
    presenter.resetPasswordOnError(e);
  }

  @override
  void onNext(response) {
    // assert(presenter.resetPasswordOnNext != null);
    // presenter.resetPasswordOnNext(response);
  }
}