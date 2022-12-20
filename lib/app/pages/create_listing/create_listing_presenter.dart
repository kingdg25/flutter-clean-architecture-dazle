import 'package:dazle/domain/usecases/listing/create_listing_usecase.dart';
import 'package:dazle/domain/usecases/listing/update_listing_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class CreateListingPresenter extends Presenter {
  Function? createListingOnNext;
  Function? createListingOnComplete;
  Function? createListingOnError;

  Function? updateListingOnNext;
  Function? updateListingOnComplete;
  Function? updateListingOnError;

  final CreateListingUseCase createListingUseCase;
  final UpdateListingUseCase updateListingUseCase;

  CreateListingPresenter(userRepo)
      : createListingUseCase = CreateListingUseCase(userRepo),
        updateListingUseCase = UpdateListingUseCase(userRepo);

  void createListing({Map? listing}) {
    createListingUseCase.execute(_CreateListingUseCaseObserver(this),
        CreateListingUseCaseParams(listing));
  }

  void updateListing(Map data) {
    updateListingUseCase.execute(
        _UpdateListingUseCaseObserver(this), UpdateListingUseCaseParams(data));
  }

  void fetchListingDetails({id}) {}

  @override
  void dispose() {
    createListingUseCase.dispose();
  }
}

class _CreateListingUseCaseObserver
    extends Observer<CreateListingUseCaseResponse> {
  final CreateListingPresenter presenter;
  _CreateListingUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.createListingOnComplete != null);
    presenter.createListingOnComplete!();
  }

  @override
  void onError(e) {
    assert(presenter.createListingOnError != null);
    presenter.createListingOnError!(e);
  }

  @override
  void onNext(response) {
    assert(presenter.createListingOnNext != null);
    presenter.createListingOnNext!(response!.listing);
  }
}

class _UpdateListingUseCaseObserver
    extends Observer<UpdateListingUseCaseResponse> {
  final CreateListingPresenter presenter;
  _UpdateListingUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.updateListingOnComplete != null);
    presenter.updateListingOnComplete!();
  }

  @override
  void onError(e) {
    assert(presenter.updateListingOnError != null);
    presenter.updateListingOnError!(e);
  }

  @override
  void onNext(response) {
    assert(presenter.updateListingOnNext != null);
    presenter.updateListingOnNext!(response!.listing);
  }
}
