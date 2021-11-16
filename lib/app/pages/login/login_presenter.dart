import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/domain/usecases/authentication/social_login_usecase.dart';
import 'package:dazle/domain/usecases/authentication/is_authenticated_usecase.dart';
import 'package:dazle/domain/usecases/authentication/login_user_usecase.dart';
import 'package:dazle/domain/usecases/authentication/forgot_password_usecase.dart';
import 'package:dazle/domain/usecases/authentication/reset_password_usecase.dart';


class LoginPresenter extends Presenter {
  Function loginUserOnNext;
  Function loginUserOnComplete;
  Function loginUserOnError;

  Function forgotPasswordOnNext;
  Function forgotPasswordOnComplete;
  Function forgotPasswordOnError;

  Function resetPasswordOnNext;
  Function resetPasswordOnComplete;
  Function resetPasswordOnError;

  Function isAuthenticatedOnNext;
  Function isAuthenticatedOnComplete;
  Function isAuthenticatedOnError;

  Function socialLoginOnNext;
  Function socialLoginOnComplete;
  Function socialLoginOnError;

  final LoginUserUseCase loginUserUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final IsAuthenticatedUseCase isAuthenticatedUseCase;
  final SocialLoginUseCase socialLoginUseCase;
  
  LoginPresenter(userRepo) 
    : loginUserUseCase = LoginUserUseCase(userRepo),
      forgotPasswordUseCase = ForgotPasswordUseCase(userRepo),
      resetPasswordUseCase = ResetPasswordUseCase(userRepo),
      isAuthenticatedUseCase = IsAuthenticatedUseCase(userRepo),
      socialLoginUseCase = SocialLoginUseCase(userRepo);
  
  void loginUser(String email, String password) {
    loginUserUseCase.execute(_LoginUserUseCaseObserver(this), LoginUserUseCaseParams(email, password));
  }

  void forgotPassword(String email) {
    forgotPasswordUseCase.execute(_ForgotPasswordUseCaseObserver(this), ForgotPasswordUseCaseParams(email));
  }

  void resetPassword(String email, String code, String password) {
    resetPasswordUseCase.execute(_ResetPasswordUseCaseObserver(this), ResetPasswordUseCaseParams(email, code, password));
  }

  void isAuthenticated() {
    isAuthenticatedUseCase.execute(_IsAuthenticatedUseCaseObserver(this), IsAuthenticatedUseCaseParams());
  }

  void socialLogin(String type) {
    socialLoginUseCase.execute(_SocialLoginUseCaseObserver(this), SocialLoginUseCaseParams(type));
  }


  @override
  void dispose() {
    loginUserUseCase.dispose();
    forgotPasswordUseCase.dispose();
    resetPasswordUseCase.dispose();
    isAuthenticatedUseCase.dispose();
    socialLoginUseCase.dispose();
  }
}



class _LoginUserUseCaseObserver extends Observer<LoginUserUseCaseResponse> {
  final LoginPresenter presenter;
  _LoginUserUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.loginUserOnComplete != null);
    presenter.loginUserOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.loginUserOnError != null);
    presenter.loginUserOnError(e);
  }

  @override
  void onNext(response) {
    assert(presenter.loginUserOnNext != null);
    presenter.loginUserOnNext(response.user);
  }
}



class _ForgotPasswordUseCaseObserver extends Observer<ForgotPasswordUseCaseResponse> {
  final LoginPresenter presenter;
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
  final LoginPresenter presenter;
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



class _IsAuthenticatedUseCaseObserver extends Observer<IsAuthenticatedUseCaseResponse> {
  final LoginPresenter presenter;
  _IsAuthenticatedUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.isAuthenticatedOnComplete != null);
    presenter.isAuthenticatedOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.isAuthenticatedOnError != null);
    presenter.isAuthenticatedOnError(e);
  }

  @override
  void onNext(response) {
    assert(presenter.isAuthenticatedOnNext != null);
    presenter.isAuthenticatedOnNext(response.isAuthenticate);
  }
}



class _SocialLoginUseCaseObserver extends Observer<SocialLoginUseCaseResponse> {
  final LoginPresenter presenter;
  _SocialLoginUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.socialLoginOnComplete != null);
    presenter.socialLoginOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.socialLoginOnError != null);
    presenter.socialLoginOnError(e);
  }

  @override
  void onNext(response) {
    assert(presenter.socialLoginOnNext != null);
    presenter.socialLoginOnNext(response.user);
  }
}