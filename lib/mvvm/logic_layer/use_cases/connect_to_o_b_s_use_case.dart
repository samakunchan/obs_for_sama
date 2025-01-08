import 'package:obs_for_sama/mvvm/data_layer/models/auth_form_model.dart';
import 'package:obs_for_sama/mvvm/data_layer/repository/o_b_s_repository.dart';

class ConnectToOBSUseCase {
  const ConnectToOBSUseCase({required this.repository});
  final OBSRepository repository;

  /// Execute the connection to [OBSRepository].
  Future<void> execute({required AuthFormModel form}) async {
    await repository.connect(form: form);
  }
}
