import 'package:obs_for_sama/mvvm/data_layer/models/auth_form_model.dart';
import 'package:obs_for_sama/mvvm/data_layer/models/obs_model.dart';
import 'package:obs_for_sama/mvvm/data_layer/service/o_b_s_service.dart';

class OBSRepository {
  const OBSRepository({required this.obsService});
  final OBSService obsService;

  Future<void> connect({required AuthFormModel form}) async {
    await obsService.connect(form: form);
  }

  Future<void> listen({required AuthFormModel form}) async {
    await obsService.listen(form: form);
  }

  Future<ProfileListResponse?> getProfile({required AuthFormModel form}) async {
    return obsService.getProfile(form: form);
  }
}
