import 'package:get_it/get_it.dart';
import 'package:sigede_movil/features/authentication/data/datasources/login_remote_data_source.dart';
import 'package:sigede_movil/features/authentication/data/repositories/login_repository.dart';
import 'package:sigede_movil/features/authentication/domain/use_cases/login.dart';
import 'package:sigede_movil/features/authentication/data/datasources/recovery_password_data_source.dart';
import 'package:sigede_movil/features/authentication/data/repositories/recovery_password_repository.dart';
import 'package:sigede_movil/features/authentication/domain/use_cases/recovery_password.dart';
import 'package:sigede_movil/config/dio_client.dart';
import 'package:sigede_movil/core/services/token_service.dart';
import 'package:sigede_movil/modules/admin/data/datasources/capturista_remote_data_source.dart';
import 'package:sigede_movil/modules/admin/data/repositories/capturista_repository.dart';
import 'package:sigede_movil/modules/admin/domain/use_cases/disable_capturista.dart';
import 'package:sigede_movil/modules/admin/domain/use_cases/get_capturista.dart';
import 'package:sigede_movil/modules/admin/domain/use_cases/get_capturistas.dart';
import 'package:sigede_movil/modules/admin/domain/use_cases/post_capturista.dart';
import 'package:sigede_movil/modules/admin/domain/use_cases/put_capturista.dart';
import 'package:sigede_movil/modules/auth/data/datasources/code_confirmation_data_source.dart';
import 'package:sigede_movil/modules/auth/data/datasources/reset_password_data_source.dart';
import 'package:sigede_movil/modules/auth/data/repositories/code_confirmation_repository.dart';
import 'package:sigede_movil/modules/auth/data/repositories/reset_password_repository.dart';
import 'package:sigede_movil/modules/auth/domain/use_cases/code_confirmation.dart';
import 'package:sigede_movil/modules/auth/domain/use_cases/reset_password.dart';
import 'package:sigede_movil/modules/superadmin/data/datasources/admin_data_source.dart';
import 'package:sigede_movil/modules/superadmin/data/datasources/institution_data_source.dart';
import 'package:sigede_movil/modules/superadmin/data/datasources/institution_post_data_source.dart';
import 'package:sigede_movil/modules/superadmin/data/datasources/institutions_all_data_source.dart';
import 'package:sigede_movil/modules/superadmin/data/repositories/admin_repository.dart';
import 'package:sigede_movil/modules/superadmin/data/repositories/institution_new_repository.dart';
import 'package:sigede_movil/modules/superadmin/data/repositories/institution_repository.dart';
import 'package:sigede_movil/modules/superadmin/data/repositories/institutions_repository.dart';
import 'package:sigede_movil/modules/superadmin/domain/use_cases/get_institutions_by_name.dart';
import 'package:sigede_movil/modules/superadmin/domain/use_cases/institutions.dart';
import 'package:sigede_movil/modules/superadmin/domain/use_cases/post_admin.dart';
import 'package:sigede_movil/modules/superadmin/domain/use_cases/post_institution.dart';

final GetIt sl = GetIt.instance;

void setupServicesl() {
  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerLazySingleton<TokenService>(() => TokenService());

  sl.registerLazySingleton<LoginRemoteDataSource>(
    () => LoginRemoteDataSourceImpl(dioClient: sl<DioClient>()),
  );
  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(loginRemoteDataSource: sl<LoginRemoteDataSource>()),
  );
  sl.registerFactory<Login>(
    () => Login(repository: sl<LoginRepository>()),
  );

  /// Registrar el CodeConfirmationDataSource
  sl.registerFactory<CodeConfirmationDataSource>(() => CodeConfirmationDataSourceImpl(dioClient: sl()));
  /// Registrar el CodeConfirmationRepository
  sl.registerFactory<CodeConfirmationRepository>(() => CodeConfirmationRepositoryImpl(codeConfirmationDataSource: sl()));
  /// Registrar el caso de uso CodeConfirmation
  sl.registerFactory<CodeConfirmation>(() => CodeConfirmation(repository: sl()));

  // Registrar el ResetPasswordDataSource
  sl.registerFactory<ResetPasswordDataSource>(() => ResetPasswordDataSourceImpl(dioClient: sl()));
  // Registrar el ResetPasswordRepository
  sl.registerFactory<ResetPasswordRepository>(() => ResetPasswordRepositoryImpl(resetPasswordDataSource: sl()));
  // Registrar el caso de uso ResetPassword
  sl.registerFactory<ResetPassword>(() => ResetPassword(repository: sl()));

  //Registrar el InstitucionDataSource
  sl.registerFactory<InstitutionsAllDataSource>(() => InstitutionsAllDataSourceImpl(dioClient: sl()));
  //Registrar el InstitucionRepository
  sl.registerFactory<InstitutionsRepository>(() => InstitutionsRepositoryImpl(institutionsAllDataSource: sl()));
  //Registrar el caso de uso Institucion
  sl.registerFactory<Institutions>(() => Institutions(repository: sl()));


  // Registro de CapturistaRemoteDataSource
  sl.registerFactory<CapturistaRemoteDataSource>(
    () => CapturistaRemoteDataSourceImpl(dioClient: sl()));
  // Repositorios capturista
  sl.registerFactory<CapturistaRepository>(
    () => CapturistaRepositoryImpl(capturistaRemoteDataSource: sl()));
  // Casos de uso capturista
  sl.registerFactory(() => GetCapturistas(repository: sl()));
  sl.registerFactory(() => GetCapturista(repository: sl()));
  sl.registerFactory(()=> PutCapturista(repository: sl()));
  sl.registerFactory(()=> DisableCapturista(repository: sl()));
  sl.registerFactory(()=>PostCapturista(repository: sl()));

  //Registrar institutionDataSource
  sl.registerFactory<InstitutionDataSource>(() => InstitutionDataSourceImpl(dioClient: sl()));
  //Registrar institutionRepository
  sl.registerFactory<InstitutionRepository>(() => InstitutionRepositoryImpl(institutionDataSource: sl()));
  //Registrar el caso de uso GetInstitutionsByName
  sl.registerFactory<GetInstitutionsByName>(() => GetInstitutionsByName(repository: sl()));

  //Registrar InstitutionPostDataSource
  sl.registerFactory<InstitutionPostDataSource>(() => InstitutionPostDataSourceImpl(dioClient: sl()));
  //Registrar InstitutionPostRepository
  sl.registerFactory<InstitutionNewRepository>(() => InstitutionNewRepositoryImpl(institutionPostDataSource: sl()));
  //Registrar el caso de uso PostInstitution
  sl.registerFactory<PostInstitution>(() => PostInstitution(repository: sl()));

  //registrar admin_data_source
  sl.registerFactory<AdminDataSource>(() => AdminDataSourceImpl(dioClient: sl()));
  //registrar admin_repository
  sl.registerFactory<AdminRepository>(() => AdminRepositoryImpl(adminDataSource: sl()));
  //registrar el caso de uso PostAdmin
  sl.registerFactory<PostAdmin>(() => PostAdmin(repository: sl()));
  
  sl.registerLazySingleton<RecoveryPasswordRemoteDataSource>(
    () => RecoveryPasswordRemoreDataSourceImpl(dioClient: sl<DioClient>()),
  );
  sl.registerLazySingleton<RecoveryPasswordRepository>(
    () => RecoveryPasswordRepositoryImpl(recoveryPasswordRemoteDataSource: sl<RecoveryPasswordRemoteDataSource>()),
  );
  sl.registerFactory<RecoveryPassword>(
    () => RecoveryPassword(repository: sl<RecoveryPasswordRepository>()),
  );
}