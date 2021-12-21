import 'package:dazle/domain/usecases/listing/get_my_collection_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class MyCollectionPresenter extends Presenter {
  Function getMyCollectionOnNext;
  Function getMyCollectionOnComplete;
  Function getMyCollectionOnError;

  final GetMyCollectionUseCase getMyCollectionUseCase;

  MyCollectionPresenter(userRepo)
    : getMyCollectionUseCase = GetMyCollectionUseCase(userRepo);
  

  void getMyCollection() {
    getMyCollectionUseCase.execute(_GetMyCollectionUseCaseObserver(this), GetMyCollectionUseCaseParams());
  }

  @override
  void dispose() {
    getMyCollectionUseCase.dispose();
  }
}



class _GetMyCollectionUseCaseObserver extends Observer<GetMyCollectionUseCaseResponse> {
  final MyCollectionPresenter presenter;
  _GetMyCollectionUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.getMyCollectionOnComplete != null);
    presenter.getMyCollectionOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.getMyCollectionOnError != null);
    presenter.getMyCollectionOnError(e);
  }

  @override
  void onNext(response) {
    assert(presenter.getMyCollectionOnNext != null);
    presenter.getMyCollectionOnNext(response.myCollection);
  }
}