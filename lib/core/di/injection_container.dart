import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:peer_connects/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:peer_connects/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:peer_connects/features/auth/domain/repositories/auth_repository.dart';
import 'package:peer_connects/features/auth/domain/usecases/get_auth_status.dart';
import 'package:peer_connects/features/auth/domain/usecases/get_current_user.dart';
import 'package:peer_connects/features/auth/domain/usecases/reset_password.dart';
import 'package:peer_connects/features/auth/domain/usecases/sign_in_with_email_and_password.dart';
import 'package:peer_connects/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:peer_connects/features/auth/domain/usecases/sign_out.dart';
import 'package:peer_connects/features/auth/domain/usecases/sign_up.dart';
import 'package:peer_connects/features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Firebase
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => GoogleSignIn());

  // Data sources
  sl.registerLazySingleton<FirebaseAuthDatasource>(
    () => FirebaseAuthDatasourceImpl(
      firebaseAuth: sl(),
      firestore: sl(),
      googleSignIn: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAuthStatus(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => SignInWithEmailAndPassword(sl()));
  sl.registerLazySingleton(() => SignInWithGoogle(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => ResetPassword(sl()));

  // BLoCs
  sl.registerFactory(
    () => AuthBloc(
      getAuthStatus: sl(),
      signUp: sl(),
      signInWithEmailAndPassword: sl(),
      signInWithGoogle: sl(),
      signOut: sl(),
      resetPassword: sl(),
    ),
  );
}