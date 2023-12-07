import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:re_frame/Widgets/postmodal.dart';
import 'package:re_frame/calendar_util.dart';
import 'package:re_frame/main.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar>
    with AutomaticKeepAliveClientMixin, MyHomePageStateMixin {
  @override
  bool get wantKeepAlive => true;

  late final ValueNotifier<List<Post>> _selectedEvents;
  FirebaseFirestore db = FirebaseFirestore.instance;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  LinkedHashMap<DateTime, List<Post>> kEvents =
      LinkedHashMap<DateTime, List<Post>>(
    equals: isSameDay,
    hashCode: getHashCode,
  ); // cascade notation.
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void getFirebasePosts() {
    CollectionReference postRef = db.collection("posts");
    postRef.snapshots().listen((event) {
      for (var element in event.docs) {
        Map<String, dynamic> postData = element.data() as Map<String, dynamic>;
        List<dynamic> peopleList = postData['people'];
        if (peopleList.contains(_firebaseAuth.currentUser?.uid)) {
          Timestamp firebaseDate = postData["date"];
          DateTime postDate = DateTime.parse(firebaseDate.toDate().toString());
          Post newPostObj = Post(
              title: postData["title"],
              content: postData["content"],
              date: postDate,
              people: postData["people"],
              photos: postData["photos"]);
          setState(() {
            if (kEvents.containsKey(postDate)) {
              kEvents[postDate]!.add(newPostObj);
            } else {
              kEvents[postDate] = [newPostObj];
            }
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();

    getFirebasePosts();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Post> _getEventsForDay(DateTime day) {
    return kEvents[day] ?? [];
  }

  List<Post> _getEventsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);
    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(children: [
      TableCalendar<Post>(
        locale: 'ko_KR',
        firstDay: kFirstDay,
        lastDay: kLastDay,
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        rangeStartDay: _rangeStart,
        rangeEndDay: _rangeEnd,
        calendarFormat: _calendarFormat,
        rangeSelectionMode: _rangeSelectionMode,
        eventLoader: _getEventsForDay,
        startingDayOfWeek: StartingDayOfWeek.monday,
        calendarStyle: const CalendarStyle(
          // Use `CalendarStyle` to customize the UI
          outsideDaysVisible: false,
        ),
        onDaySelected: _onDaySelected,
        onRangeSelected: _onRangeSelected,
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        calendarBuilders:
            CalendarBuilders(markerBuilder: (context, date, dynamic event) {
          if (event.isNotEmpty) {
            return Container(
              width: 35,
              decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2), shape: BoxShape.circle),
            );
          }
          return null;
        }),
      ),
      const SizedBox(height: 8.0),
      Expanded(
        child: ValueListenableBuilder<List<Post>>(
          valueListenable: _selectedEvents,
          builder: (context, value, _) {
            return ListView.builder(
              itemCount: value.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PostModal(post: value[index])));
                    },
                    title: Text('${value[index]}'),
                  ),
                );
              },
            );
          },
        ),
      ),
    ]);
  }

  @override
  void onPageVisible() {
    MyHomePage.of(context)?.params = AppBarParams();
  }
}
