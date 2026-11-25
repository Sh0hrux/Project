import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:startup_app/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:startup_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:startup_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:startup_app/features/profile/presentation/screens/profile_screen.dart';

void main() {
  late ProfileBloc profileBloc;

  setUp(() {
    profileBloc = ProfileBloc(
      profileRepository: ProfileRepositoryImpl(
        remoteDataSource: MockProfileRemoteDataSourceImpl(),
      ),
    );
  });

  tearDown(() {
    profileBloc.close();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<ProfileBloc>.value(
        value: profileBloc,
        child: const ProfileScreen(),
      ),
    );
  }

  group('ProfileScreen Widget Tests', () {
    testWidgets('Profil ma\'lumotlari ko\'rinadi va tahrirlash ishlaydi',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump();

      expect(find.text('Shohrux'), findsOneWidget);
      expect(find.text('user@startup.uz'), findsOneWidget);
      expect(find.text('S'), findsOneWidget);

      await tester.tap(find.byKey(const Key('profile_edit_toggle_button')));
      await tester.pump();

      expect(find.byKey(const Key('profile_name_input')), findsOneWidget);
      expect(find.byKey(const Key('profile_save_button')), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('profile_name_input')),
        'Ali',
      );
      await tester.tap(find.byKey(const Key('profile_save_button')));
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump();

      expect(find.text('Ali'), findsOneWidget);
      expect(find.text('A'), findsOneWidget);
    });
  });
}
