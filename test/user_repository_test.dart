import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unit_test_with_api/user_model.dart';
import 'package:unit_test_with_api/user_repository.dart';

class MockHTTPClient extends Mock implements Client {}

void main() {
  late UserRepository userRepository;
  late MockHTTPClient mockHTTPClient;
  setUp(() {
    mockHTTPClient = MockHTTPClient();
    userRepository = UserRepository(mockHTTPClient);
  });

  group('User Repository- ', () {
    group('getUser function', () {
      test(
        'When the status code is 200 then a user model should be returned',
        () async {
          //Arrange
          when(
            () => mockHTTPClient.get(
              Uri.parse('https://jsonplaceholder.typicode.com/users/1'),
            ),
          ).thenAnswer((invocation) async {
            return Response(''' 
                    {
            "id": 1,
            "name": "Leanne Graham",
            "username": "Bret",
            "email": "Sincere@april.biz",
            "website": "hildegard.org"
        }
          ''', 200);
          });
          //Act
          final user = await userRepository.getUser();
          //Assert
          expect(user, isA<User>());
        },
      );

      test('When the status code is not 200 an exception should be thrown',
          () async {
        //Arrange
        when(
          () => mockHTTPClient.get(
            Uri.parse('https://jsonplaceholder.typicode.com/users/1'),
          ),
        ).thenAnswer((invocation) async {
          return Response('{}', 500);
        });
        //Act
        final user = userRepository.getUser();
        //Assert
        expect(user, throwsException);
      });
    });
  });
}
