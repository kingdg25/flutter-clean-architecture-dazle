import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/domain/usecases/listing/get_selected_listing_usecase.dart';
import 'package:dazle/domain/usecases/listing/delete_listing_usecase.dart';

class ListingDetailsPresenter extends Presenter {
  Function? getSelectedListingOnNext;
  Function? getSelectedListingOnComplete;
  Function? getSelectedListingOnError;

  Function? deleteListinOnNext;
  Function? deleteListinOnComplete;
  Function? deleteListinOnError;

  final GetSelectedListingUseCase getSelectedListingUseCase;
  final DeleteListingUseCase deleteListingUseCase;

  ListingDetailsPresenter(dataListingRepository)
      : getSelectedListingUseCase =
            GetSelectedListingUseCase(dataListingRepository),
        deleteListingUseCase = DeleteListingUseCase(dataListingRepository);

  void getSelectedListing(String listingId) {
    getSelectedListingUseCase.execute(_GetSelectedListingUseCaseObeserver(this),
        GetSelectedListingUseCaseParams(listingId));
  }

  void deleteListing(String listingId) {
    deleteListingUseCase.execute(_DeleteListingUseCaseObserver(this),
        DeleteListingUseCaseParams(listingId));
  }

  @override
  void dispose() {
    getSelectedListingUseCase.dispose();
    deleteListingUseCase.dispose();
  }
}

class _GetSelectedListingUseCaseObeserver
    extends Observer<GetSelectedListingUseCaseResponse> {
  final ListingDetailsPresenter presenter;

  _GetSelectedListingUseCaseObeserver(this.presenter);

  @override
  void onComplete() {
    assert(presenter.getSelectedListingOnComplete != null);
    presenter.getSelectedListingOnComplete!();
  }

  @override
  void onError(e) {
    assert(presenter.getSelectedListingOnError != null);
    presenter.getSelectedListingOnError!(e);
  }

  @override
  void onNext(response) {
    assert(presenter.getSelectedListingOnNext != null);
    presenter.getSelectedListingOnNext!(response!.selectedListing);
  }
}

class _DeleteListingUseCaseObserver extends Observer<void> {
  final ListingDetailsPresenter presenter;

  _DeleteListingUseCaseObserver(this.presenter);

  @override
  void onComplete() {
    assert(presenter.deleteListinOnComplete != null);
    presenter.deleteListinOnComplete!();
  }

  @override
  void onError(e) {
    assert(presenter.deleteListinOnError != null);
    presenter.deleteListinOnError!(e);
  }

  @override
  void onNext(response) {}
}
