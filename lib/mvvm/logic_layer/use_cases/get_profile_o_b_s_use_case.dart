import 'package:obs_for_sama/mvvm/data_layer/models/auth_form_model.dart';
import 'package:obs_for_sama/mvvm/data_layer/models/obs_model.dart';
import 'package:obs_for_sama/mvvm/data_layer/repository/o_b_s_repository.dart';

class GetProfileOBSUseCase {
  const GetProfileOBSUseCase({required this.repository});
  final OBSRepository repository;

  /// Execute the connection to [OBSRepository].
  Future<ProfileListResponse?> execute({required AuthFormModel form}) async {
    return repository.getProfile(form: form);
  }
}
