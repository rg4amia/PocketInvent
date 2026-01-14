import 'package:hive/hive.dart';

part 'period.g.dart';

@HiveType(typeId: 4)
enum PeriodType {
  @HiveField(0)
  today,
  @HiveField(1)
  thisWeek,
  @HiveField(2)
  thisMonth,
  @HiveField(3)
  thisYear,
  @HiveField(4)
  all,
  @HiveField(5)
  custom,
}

@HiveType(typeId: 5)
class Period extends HiveObject {
  @HiveField(0)
  final PeriodType type;

  @HiveField(1)
  final DateTime? startDate;

  @HiveField(2)
  final DateTime? endDate;

  // Unnamed constructor for Hive
  Period({
    required this.type,
    this.startDate,
    this.endDate,
  });

  // Named constructors for predefined periods
  Period.today() : this(type: PeriodType.today);

  Period.thisWeek() : this(type: PeriodType.thisWeek);

  Period.thisMonth() : this(type: PeriodType.thisMonth);

  Period.thisYear() : this(type: PeriodType.thisYear);

  Period.all() : this(type: PeriodType.all);

  Period.custom(DateTime startDate, DateTime endDate)
      : this(
          type: PeriodType.custom,
          startDate: startDate,
          endDate: endDate,
        );

  // Get the actual start date based on period type
  DateTime getStartDate() {
    final now = DateTime.now();

    switch (type) {
      case PeriodType.today:
        return DateTime(now.year, now.month, now.day);

      case PeriodType.thisWeek:
        // Start of week (Monday)
        final weekday = now.weekday;
        return DateTime(now.year, now.month, now.day - (weekday - 1));

      case PeriodType.thisMonth:
        return DateTime(now.year, now.month, 1);

      case PeriodType.thisYear:
        return DateTime(now.year, 1, 1);

      case PeriodType.all:
        // Return a very old date to include all records
        return DateTime(2000, 1, 1);

      case PeriodType.custom:
        return startDate ?? DateTime(2000, 1, 1);
    }
  }

  // Get the actual end date based on period type
  DateTime getEndDate() {
    final now = DateTime.now();

    switch (type) {
      case PeriodType.today:
        return DateTime(now.year, now.month, now.day, 23, 59, 59);

      case PeriodType.thisWeek:
        // End of week (Sunday)
        final weekday = now.weekday;
        return DateTime(
            now.year, now.month, now.day + (7 - weekday), 23, 59, 59);

      case PeriodType.thisMonth:
        // Last day of current month
        final nextMonth = now.month == 12 ? 1 : now.month + 1;
        final year = now.month == 12 ? now.year + 1 : now.year;
        return DateTime(year, nextMonth, 0, 23, 59, 59);

      case PeriodType.thisYear:
        return DateTime(now.year, 12, 31, 23, 59, 59);

      case PeriodType.all:
        // Return current date/time
        return now;

      case PeriodType.custom:
        return endDate ?? now;
    }
  }

  factory Period.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String;
    final type = PeriodType.values.firstWhere(
      (e) => e.name == typeStr,
      orElse: () => PeriodType.all,
    );

    if (type == PeriodType.custom) {
      return Period.custom(
        DateTime.parse(json['start_date']),
        DateTime.parse(json['end_date']),
      );
    }

    switch (type) {
      case PeriodType.today:
        return Period.today();
      case PeriodType.thisWeek:
        return Period.thisWeek();
      case PeriodType.thisMonth:
        return Period.thisMonth();
      case PeriodType.thisYear:
        return Period.thisYear();
      case PeriodType.all:
      default:
        return Period.all();
    }
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'type': type.name,
    };

    if (type == PeriodType.custom && startDate != null && endDate != null) {
      json['start_date'] = startDate!.toIso8601String();
      json['end_date'] = endDate!.toIso8601String();
    }

    return json;
  }

  Period copyWith({
    PeriodType? type,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Period(
      type: type ?? this.type,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Period &&
        other.type == type &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode => type.hashCode ^ startDate.hashCode ^ endDate.hashCode;

  @override
  String toString() {
    if (type == PeriodType.custom) {
      return 'Period.custom(${startDate?.toIso8601String()} - ${endDate?.toIso8601String()})';
    }
    return 'Period.${type.name}()';
  }
}
