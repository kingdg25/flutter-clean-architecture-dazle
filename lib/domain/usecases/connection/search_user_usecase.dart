import 'dart:async';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/data/repositories/data_connection_repository.dart';
import 'package:dazle/domain/entities/user.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';


class SearchUserUseCase extends UseCase<SearchUserUseCaseResponse, SearchUserUseCaseParams>{
  final DataConnectionRepository dataConnectionRepository;
  SearchUserUseCase(this.dataConnectionRepository);

  @override
  Future<Stream<SearchUserUseCaseResponse>> buildUseCaseStream(SearchUserUseCaseParams params) async {
    final controller = StreamController<SearchUserUseCaseResponse>();

    try {
      // search user
      User user = await App.getUser();
      if (user != null) {
        final data = await dataConnectionRepository.searchUser(userId: user.id, pattern: params.pattern, invited: params.invited);
        controller.add(SearchUserUseCaseResponse(data));
        logger.finest('Search User successful.');
      }
      else {
        logger.severe('Search User fail.');
        controller.addError('user data is null');
      }

      controller.close();
    } catch (e) {
      logger.severe('Search User fail.');
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }
  
}




class SearchUserUseCaseParams {
  final String pattern;
  final bool invited;
  SearchUserUseCaseParams(this.pattern, this.invited);
}

class SearchUserUseCaseResponse {
  List<String> data;
  SearchUserUseCaseResponse(this.data);
}
