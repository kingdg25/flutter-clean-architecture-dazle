import 'package:dazle/domain/usecases/connection/read_my_connection_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class MyConnectionPresenter extends Presenter {
  Function readMyConnectionOnNext;
  Function readMyConnectionOnComplete;
  Function readMyConnectionOnError;

  final ReadMyConnectionUseCase readMyConnectionUseCase;

  MyConnectionPresenter(userRepo)
    : readMyConnectionUseCase = ReadMyConnectionUseCase(userRepo);

  void readMyConnection(){
    readMyConnectionUseCase.execute(_ReadMyConnectionUseCaseObserver(this), ReadMyConnectionUseCaseParams());
  }
  
  @override
  void dispose() {
    readMyConnectionUseCase.dispose();
  }
}



class _ReadMyConnectionUseCaseObserver extends Observer<ReadMyConnectionUseCaseResponse> {
  final MyConnectionPresenter presenter;
  _ReadMyConnectionUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.readMyConnectionOnComplete != null);
    presenter.readMyConnectionOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.readMyConnectionOnError != null);
    presenter.readMyConnectionOnError(e);
  }

  @override
  void onNext(response) {
    assert(presenter.readMyConnectionOnNext != null);
    presenter.readMyConnectionOnNext(response.myConnection);
  }
}