import 'package:dazle/domain/usecases/listing/get_my_listing_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class MyListingPresenter extends Presenter {
  Function? getMyListingOnNext;
  Function? getMyListingOnComplete;
  Function? getMyListingOnError;

  final GetMyListingUseCase getMyListingUseCase;

  MyListingPresenter(userRepo)
    : getMyListingUseCase = GetMyListingUseCase(userRepo);
  

  void getMyListing() {
    getMyListingUseCase.execute(_GetMyListingUseCaseObserver(this), GetMyListingUseCaseParams());
  }

  @override
  void dispose() {
    getMyListingUseCase.dispose();
  }
}


class _GetMyListingUseCaseObserver extends Observer<GetMyListingUseCaseResponse> {
  final MyListingPresenter presenter;
  _GetMyListingUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.getMyListingOnComplete != null);
    presenter.getMyListingOnComplete!();
  }

  @override
  void onError(e) {
    assert(presenter.getMyListingOnError != null);
    presenter.getMyListingOnError!(e);
  }

  @override
  void onNext(response) {
    assert(presenter.getMyListingOnNext != null);
    presenter.getMyListingOnNext!(response!.myListing);
  }
}