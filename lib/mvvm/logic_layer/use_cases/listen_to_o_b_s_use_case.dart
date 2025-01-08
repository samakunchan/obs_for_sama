import 'package:obs_for_sama/mvvm/data_layer/models/auth_form_model.dart';
import 'package:obs_for_sama/mvvm/data_layer/repository/o_b_s_repository.dart';

class ListenToOBSUseCase {
  const ListenToOBSUseCase({required this.repository});
  final OBSRepository repository;

  Future<void> execute({required AuthFormModel form}) async {
    await repository.listen(form: form);
  }
}
