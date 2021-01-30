import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wasfat_web/providers/add_wasfa_provider.dart';
import 'package:wasfat_web/providers/auth_provider.dart';
import 'package:wasfat_web/providers/categorylist_provider.dart';
import 'package:wasfat_web/providers/images_provider.dart';

final getIt = GetIt.instance;

void getInit() {
  getIt.registerFactory<Auth>(() => Auth(
        getIt<GoogleSignIn>(),
        getIt<FirebaseAuth>(),
        getIt<FirebaseFirestore>(),
        getIt<SharedPreferences>(),
      ));
  getIt.registerFactory<CategoryListProvider>(() => CategoryListProvider(
        getIt<FirebaseFirestore>(),
      ));
  getIt.registerFactory<AddWasfaProvider>(() => AddWasfaProvider(
        getIt<FirebaseFirestore>(),
      ));
  getIt.registerFactory<ImagesProvider>(() => ImagesProvider(
        getIt<FilePicker>(),
        getIt<FirebaseStorage>(),
      ));
  getIt.registerLazySingleton<FilePicker>(() => FilePicker.platform);
  getIt.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn.standard());
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);
  getIt.registerSingletonAsync<SharedPreferences>(
      () async => await SharedPreferences.getInstance());
}
