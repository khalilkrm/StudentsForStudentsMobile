import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:student_for_student_mobile/apis/horairix_api.dart';
import 'package:student_for_student_mobile/models/horairix/HorairixApiEventModel.dart';
import 'package:student_for_student_mobile/models/horairix/HorairixApiModel.dart';
import 'package:student_for_student_mobile/repositories/horairix_repository.dart';

import 'horairix_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<HorairixApi>()])
void main() async {
  MockHorairixApi api = MockHorairixApi();
  HorairixRepository repository = HorairixRepository(horairixApi: api);
  final List<HorairixApiEventModel> fakeEventsFromApi = _getFakApiEventModel();
  final HorairixApiModel fakeModel =
      HorairixApiModel(data: fakeEventsFromApi, error: false);

  whenFetchTimeSheetThenAnswer(HorairixApiModel model) {
    when(api.fetchTimeSheet(token: "token"))
        .thenAnswer((_) => Future.value(model));
  }

  setUp(() {
    repository = HorairixRepository(horairixApi: api);
  });

  group('HorairixRepository', () {
    test('all events are loaded if api has "data" field', () async {
      whenFetchTimeSheetThenAnswer(fakeModel);
      await repository.loadAllEvents(token: "token");
      expect(repository.events, isA<List>());
      expect(repository.events.length, 5);

      for (var event in repository.events) {
        expect(event.description, isNotNull);
        expect(event.description, isA<String>());
        expect(event.endDate, isNotNull);
        expect(event.endDate, isA<DateTime>());
        expect(event.startDate, isNotNull);
        expect(event.startDate, isA<DateTime>());
        expect(event.location, isNotNull);
        expect(event.location, isA<String>());
        expect(event.summary, isNotNull);
        expect(event.summary, isA<String>());
        expect(event.uid, isNotNull);
        expect(event.uid, isA<String>());
      }
    });

    test('event are null and error to false if data has not "data" field', () {
      whenFetchTimeSheetThenAnswer(HorairixApiModel(data: null, error: false));
      expect(repository.events, isNotNull);
      expect(repository.events.length, 0);
    });
  });
}

List<HorairixApiEventModel> _getFakApiEventModel() {
  List decoded = jsonDecode(data);
  List<HorairixApiEventModel> events = [];

  for (var d in decoded) {
    events.add(HorairixApiEventModel.fromJson(d));
  }

  return events;
}

String malformedData = """[{
    "dtend": {"dt": "2021-12-15T13:08:12Z"},
    "dtstart": {"dt": "2022-03-06T18:59:23Z"},
    "location": "China",
    "summary": "Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl.",
    "description": "Female",
    "uid": "a4785493-c530-419a-81f5-7a8996f4fd97"
  }]""";

String data = """[{
    "dtend": {"dt": "2021-12-15T13:08:12Z"},
    "dtstart": {"dt": "2022-03-06T18:59:23Z"},
    "location": "China",
    "summary": "Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl.",
    "description": "Female",
    "uid": "a4785493-c530-419a-81f5-7a8996f4fd97"
  }, {
    "dtend": {"dt": "2022-10-23T15:56:06Z"},
    "dtstart": {"dt": "2022-04-12T15:54:32Z"},
    "location": "Russia",
    "summary": "Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius.",
    "description": "Female",
    "uid": "557ad22e-e067-48de-898a-9a30dc0ad9a6"
  }, {
    "dtend": {"dt": "2022-03-18T11:20:07Z"},
    "dtstart": {"dt": "2022-04-10T20:36:11Z"},
    "location": "Russia",
    "summary": "Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula.",
    "description": "Female",
    "uid": "14b8b584-8138-4fbe-a6de-1ce35ee03805"
  }, {
    "dtend": {"dt": "2022-04-01T05:26:53Z"},
    "dtstart": {"dt": "2022-03-06T04:08:15Z"},
    "location": "Ireland",
    "summary": "Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor.",
    "description": "Male",
    "uid": "56c60c4c-75d7-4356-8e8b-fa1dc0356ae2"
  }, {
    "dtend": {"dt": "2022-01-25T22:18:14Z"},
    "dtstart": {"dt": "2022-05-13T01:22:17Z"},
    "location": "Russia",
    "summary": "Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.",
    "description": "Female",
    "uid": "ca498c37-e4a8-4ec4-ab61-b159e343112e"
  }]""";
