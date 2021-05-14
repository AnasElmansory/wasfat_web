import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wasfat_web/firebase/category_service.dart';
import 'package:wasfat_web/firebase/dishes_services.dart';
import 'package:wasfat_web/providers/add_dish_provider.dart';
import 'package:wasfat_web/providers/auth_provider.dart';
import 'package:wasfat_web/providers/category_provider.dart';
import 'package:wasfat_web/providers/dishes_provider.dart';
import 'package:wasfat_web/providers/edit_dish_provider.dart';
import 'package:wasfat_web/providers/images_provider.dart';

final getIt = GetIt.instance;

void getInit() {
  getIt.registerFactory<Auth>(() => Auth(
        getIt<FirebaseAuth>(),
        getIt<FirebaseFirestore>(),
      ));
  getIt.registerFactory<CategoriesProvider>(() => CategoriesProvider(
        getIt<CategoryService>(),
      ));
  getIt.registerFactory<AddDishProvider>(() => AddDishProvider(
        getIt<DishesService>(),
      ));
  getIt.registerFactory<EditDishProvider>(() => EditDishProvider(
        getIt<DishesService>(),
      ));
  getIt.registerFactory<ImagesProvider>(() => ImagesProvider(
        getIt<FilePicker>(),
        getIt<FirebaseStorage>(),
      ));
  getIt.registerFactory<DishesProvider>(() => DishesProvider(
        getIt<DishesService>(),
      ));

  getIt.registerLazySingleton<DishesService>(
      () => DishesService(getIt<FirebaseFirestore>()));
  getIt.registerLazySingleton<FilePicker>(() => FilePicker.platform);
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);
  getIt.registerLazySingleton<CategoryService>(
      () => CategoryService(getIt<FirebaseFirestore>()));
  getIt.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);

  getIt.registerSingletonAsync<SharedPreferences>(
      () async => await SharedPreferences.getInstance());
}
