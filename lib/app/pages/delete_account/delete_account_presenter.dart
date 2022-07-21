import 'package:dazle/data/repositories/data_listing_repository.dart';
import 'package:dazle/domain/entities/user.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/domain/usecases/authentication/delete_account_code_usecase.dart';
import 'package:dazle/domain/usecases/authentication/check_delete_account_code_usecase.dart';
import 'package:dazle/domain/usecases/authentication/verify_password_usecase.dart';
import 'package:dazle/domain/usecases/profile/check_login_type_usecase.dart';
import 'package:dazle/domain/usecases/profile/deactivate_activate_account_usecase.dart';
import 'package:dazle/domain/usecases/listing/delete_all_user_listing_usecase.dart';
import 'package:dazle/domain/usecases/profile/delete_account_usecase.dart';

class DeleteAccountPresenter extends Presenter {
  // Function? deleteAccountOnNext;
  // Function? deleteAccountOnComplete;
  // Function? deleteAccountOnError;

  Function? deleleteAccountCodeOnNext;
  Function? deleleteAccountCodeOnComplete;
  Function? deleleteAccountCodeOnError;

  Function? checkDeleteAccountCodeOnNext;
  Function? checkDeleteAccountCodeOnComplete;
  Function? checkDeleteAccountCodeOnError;

  Function? deactivateActivateAccountOnNext;
  Function? deactivateActivateAccountOnComplete;
  Function? deactivateActivateAccountOnError;

  Function? checkLoginTypeOnNext;
  Function? checkLoginTypeOnComplete;
  Function? checkLoginTypeOnError;

  Function? verifyPasswordOnNext;
  Function? verifyPasswordOnComplete;
  Function? verifyPasswordOnError;

  Function? deleteAllUserListingOnNext;
  Function? deleteAllUserListingOnComplete;
  Function? deleteAllUserListingOnError;

  Function? deleteAccountOnNext;
  Function? deleteAccountOnComplete;
  Function? deleteAccountOnError;

  //* USECASES
  final DeleteAccountCodeUseCase deleteAccountCodeUseCase;
  final CheckDeleteAccountCodeUseCase checkDeleteAccountCodeUseCase;
  final DeactivateActivateAccountUseCase deactivateActivateAccountUseCase;
  final CheckLoginTypeUseCase checkLoginTypeUseCase;
  final VerifyPasswordUseCase verifyPasswordUseCase;
  final DeleteAllUserListingUseCase deleteAllUserListingUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;

  DeleteAccountPresenter(userRepo, dataProfileRepository, dataListingRepository)
      : deleteAccountCodeUseCase = DeleteAccountCodeUseCase(userRepo),
        checkDeleteAccountCodeUseCase = CheckDeleteAccountCodeUseCase(userRepo),
        deactivateActivateAccountUseCase =
            DeactivateActivateAccountUseCase(dataProfileRepository),
        checkLoginTypeUseCase = CheckLoginTypeUseCase(dataProfileRepository),
        verifyPasswordUseCase = VerifyPasswordUseCase(userRepo),
        deleteAllUserListingUseCase =
            DeleteAllUserListingUseCase(dataListingRepository),
        deleteAccountUseCase = DeleteAccountUseCase(dataProfileRepository);

  void deleteAccount({String? userId}) {
    deleteAccountUseCase.execute(_DeleteAccountUseCaseObserver(this),
        DeleteAccountUseCaseParams(userId));
  }

  void deleteAccountCode({String? email}) {
    deleteAccountCodeUseCase.execute(_DeleteAccountCodeUseCaseObserver(this),
        DeleteAccountCodeUseCaseParams(email));
  }

  void checkDeleteAccountCode({String? email, String? code}) {
    checkDeleteAccountCodeUseCase.execute(
        _CheckDeleteAccountCodeUseCaseObserver(this),
        CheckDeleteAccountCodeUseCaseParams(email, code));
  }

  void deactivateActivateAccount({User? user}) {
    deactivateActivateAccountUseCase.execute(
        _DeactivateActivateAccountUseCaseObserver(this),
        DeactivateActivateAccountUseCaseParams(user));
  }

  void checkLoginType({User? user}) async {
    checkLoginTypeUseCase.execute(_CheckLoginTypeUseCaseObserver(this),
        CheckLoginTypeUseCaseParams(user));
  }

  void verifyPassword({String? email, String? password}) async {
    verifyPasswordUseCase.execute(_VerifyPasswordUseCaseObserver(this),
        VerifyPasswordUseCaseParams(email, password));
  }

  void deleteAllUserListing({String? createdById}) {
    deleteAllUserListingUseCase.execute(
        _DeleteAllUserListingUseCaseObserver(this),
        DeleteAllUserListingUseCaseParams(createdById));
  }

  @override
  void dispose() {
    deleteAccountCodeUseCase.dispose();
    checkDeleteAccountCodeUseCase.dispose();
    deactivateActivateAccountUseCase.dispose();
    checkLoginTypeUseCase.dispose();
    verifyPasswordUseCase.dispose();
    deleteAllUserListingUseCase.dispose();
  }
}

class _DeleteAccountUseCaseObserver extends Observer<void> {
  final DeleteAccountPresenter presenter;

  _DeleteAccountUseCaseObserver(this.presenter);

  @override
  void onComplete() {
    assert(presenter.deleteAccountOnComplete != null);
    presenter.deleteAccountOnComplete!();
  }

  @override
  void onError(e) {
    assert(presenter.deleteAccountOnError != null);
    presenter.deleteAccountOnError!(e);
  }

  @override
  void onNext(response) {}
}

class _DeleteAllUserListingUseCaseObserver extends Observer<void> {
  final DeleteAccountPresenter presenter;

  _DeleteAllUserListingUseCaseObserver(this.presenter);

  @override
  void onComplete() {
    assert(presenter.deleteAllUserListingOnComplete != null);
    presenter.deleteAllUserListingOnComplete!();
  }

  @override
  void onError(e) {
    assert(presenter.deleteAllUserListingOnError != null);
    presenter.deleteAllUserListingOnError!(e);
  }

  @override
  void onNext(response) {}
}

class _VerifyPasswordUseCaseObserver
    extends Observer<VerifyPasswordUseCaseResponse> {
  final DeleteAccountPresenter presenter;

  _VerifyPasswordUseCaseObserver(this.presenter);

  @override
  void onComplete() {
    assert(presenter.verifyPasswordOnComplete != null);
    presenter.verifyPasswordOnComplete!();
  }

  @override
  void onError(e) {
    assert(presenter.verifyPasswordOnError != null);
    presenter.verifyPasswordOnError!(e);
  }

  @override
  void onNext(response) {}
}

// Check login type
class _CheckLoginTypeUseCaseObserver
    extends Observer<CheckLoginTypeUseCaseResponse> {
  final DeleteAccountPresenter presenter;

  _CheckLoginTypeUseCaseObserver(this.presenter);

  @override
  void onComplete() {
    assert(presenter.checkLoginTypeOnComplete != null);
    presenter.checkLoginTypeOnComplete!();
  }

  @override
  void onError(e) {
    assert(presenter.checkLoginTypeOnError != null);
    presenter.checkLoginTypeOnError!(e);
  }

  @override
  void onNext(response) {
    assert(presenter.checkLoginTypeOnNext != null);
    presenter.checkLoginTypeOnNext!(response!.loginType);
  }
}

/// Sending Delete Account Code Observer
class _DeleteAccountCodeUseCaseObserver
    extends Observer<DeleteAccountCodeUseCaseResponse> {
  final DeleteAccountPresenter presenter;

  _DeleteAccountCodeUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.deleleteAccountCodeOnComplete != null);
    presenter.deleleteAccountCodeOnComplete!();
  }

  @override
  void onError(e) {
    assert(presenter.deleleteAccountCodeOnError != null);
    presenter.deleleteAccountCodeOnError!(e);
  }

  @override
  void onNext(response) {
    assert(presenter.deleleteAccountCodeOnNext != null);
    presenter.deleleteAccountCodeOnNext!(response!.code);
  }
}

//Deavtivate Activate Account
class _DeactivateActivateAccountUseCaseObserver extends Observer<void> {
  final DeleteAccountPresenter presenter;

  _DeactivateActivateAccountUseCaseObserver(this.presenter);

  @override
  void onComplete() {
    assert(presenter.deactivateActivateAccountOnComplete != null);
    presenter.deactivateActivateAccountOnComplete!();
  }

  @override
  void onError(e) {
    assert(presenter.deactivateActivateAccountOnError != null);
    presenter.deactivateActivateAccountOnError!(e);
  }

  @override
  void onNext(response) {}
}

class _CheckDeleteAccountCodeUseCaseObserver
    extends Observer<CheckDeleteAccountCodeUseCaseResponse> {
  final DeleteAccountPresenter presenter;

  _CheckDeleteAccountCodeUseCaseObserver(this.presenter);

  @override
  void onComplete() {
    assert(presenter.checkDeleteAccountCodeOnComplete != null);
    presenter.checkDeleteAccountCodeOnComplete!();
  }

  @override
  void onError(e) {
    assert(presenter.checkDeleteAccountCodeOnError != null);
    presenter.checkDeleteAccountCodeOnError!(e);
  }

  @override
  void onNext(response) {}
}
