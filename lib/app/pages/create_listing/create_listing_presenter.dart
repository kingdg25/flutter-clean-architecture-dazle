import 'package:dazle/domain/entities/property.dart';
import 'package:dazle/domain/usecases/listing/create_listing_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class CreateListingPresenter extends Presenter {
  Function createListingOnNext;
  Function createListingOnComplete;
  Function createListingOnError;

  final CreateListingUseCase createListingUseCase;

  CreateListingPresenter(userRepo)
    : createListingUseCase = CreateListingUseCase(userRepo);

  
  void createListing({Map listing}){
    createListingUseCase.execute(_CreateListingUseCaseObserver(this), CreateListingUseCaseParams(listing));
  }

  void updateListing(Map data) {

  }

  void fetchListingDetails({id}){
    
  }

  @override
  void dispose() {
    createListingUseCase.dispose();
  }
}



class _CreateListingUseCaseObserver extends Observer<CreateListingUseCaseResponse> {
  final CreateListingPresenter presenter;
  _CreateListingUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.createListingOnComplete != null);
    presenter.createListingOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.createListingOnError != null);
    presenter.createListingOnError(e);
  }

  @override
  void onNext(response) {
    assert(presenter.createListingOnNext !=null);
    presenter.createListingOnNext(response.listing);
  }
}