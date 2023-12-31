// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

/// Example event class.
class Post {
  final String id;
  final String title;
  final String content;
  final DateTime date;
  final List<dynamic> people;
  final List<dynamic> photos;

  Post(
      {required this.id,
      required this.title,
      required this.content,
      required this.date,
      required this.people,
      required this.photos});

  @override
  String toString() => title;
  bool isSameId(Post curPost) => curPost.id == id;

  String prettyDateFormat() {
    return "${date.hour} : ${date.minute}";
  }
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

// final _kEventSource = {
//   DateTime.utc(2023, 11, 25): [Post(title: "hello"), Post(title: "world!")]
// }..addAll({
//   kToday: [
//     Post(title: 'Today\'s Event 1'),
//     Post(title: 'Today\'s Event 2'),
//   ],
// });

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
