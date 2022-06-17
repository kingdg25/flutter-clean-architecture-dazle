import 'dart:ffi';
import 'dart:html';

import 'package:dazle/domain/entities/user.dart';
import 'package:dazle/domain/usecases/profile/create_feedback_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class CreateFeedbackPresenter extends Presenter {
  Function? createFeedbackOnNext;
  Function? createFeedbackOnComplete;
  Function? createFeedbackOnError;

  final CreateFeedbackUsecase createFeedbackUsecase;

  CreateFeedbackPresenter(userRepo)
      : createFeedbackUsecase = CreateFeedbackUsecase(userRepo);

  void createFeedback({UserFeedback? feedback}) {
    createFeedbackUsecase.execute(_CreateFeedbackUseCaseObserver(this),
        CreateFeedbackUsecaseParams(feedback));
  }

  @override
  void dispose() {
    createFeedbackUsecase.dispose();
  }
}

class _CreateFeedbackUseCaseObserver
    extends Observer<CreateFeedbackUsecaseResponse> {
  final CreateFeedbackPresenter presenter;
  _CreateFeedbackUseCaseObserver(this.presenter);

  @override
  void onComplete() {
    assert(presenter.createFeedbackOnComplete != null);
    presenter.createFeedbackOnComplete!();
  }

  @override
  void onError(e) {
    assert(presenter.createFeedbackOnError != null);
    presenter.createFeedbackOnError!(e);
  }

  @override
  void onNext(response) {
    assert(presenter.createFeedbackOnNext != null);
    presenter.createFeedbackOnNext!(response!.feedback);
  }
}
