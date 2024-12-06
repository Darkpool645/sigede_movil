import 'package:get_it/get_it.dart';
import 'package:sigede_movil/features/authentication/data/datasources/login_remote_data_source.dart';
import 'package:sigede_movil/features/authentication/data/repositories/login_repository.dart';
import 'package:sigede_movil/features/authentication/domain/use_cases/login.dart';
import 'package:sigede_movil/config/dio_client.dart';
import 'package:sigede_movil/core/services/token_service.dart';

final GetIt sl = GetIt.instance;

void setupServiceLocator() {
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

}