import 'package:dazle/data/repositories/data_listing_repository.dart';
import 'package:dazle/domain/usecases/profile/get_user_listings_usercase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class ProfilePresenter extends Presenter {
  Function getUserListingOnNext;
  Function getUserListingOnComplete;
  Function getUserListingOnError;

  final GetUserListingsUseCase getUserListingUseCase;
  
  ProfilePresenter()
    : getUserListingUseCase = GetUserListingsUseCase(DataListingRepository());

  void getUserListing(uid) {
    getUserListingUseCase.execute(_GetUserListingUseCaseObserver(this), GetUserListingsUseCaseParams(uid: uid));
  }

  @override
  void dispose() {
  }
}

class _GetUserListingUseCaseObserver extends Observer<GetUserListingsUseCaseResponse> {
  final ProfilePresenter presenter;

  _GetUserListingUseCaseObserver(this.presenter);
  
  @override
  void onComplete() {
    assert(presenter.getUserListingOnComplete != null);
    presenter.getUserListingOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.getUserListingOnError != null);
    presenter.getUserListingOnError();
  }
  
    @override
    void onNext(GetUserListingsUseCaseResponse response) {
    assert(presenter.getUserListingOnNext != null);
    presenter.getUserListingOnNext(response.listings);
  }

}