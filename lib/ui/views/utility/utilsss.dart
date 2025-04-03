String formatDate(DateTime d) {
  return d.toString().substring(0, 19);
}

String formatDateForProvider(DateTime d) {
  String formattedMonth = d.month < 10 ? '0${d.month}' : '${d.month}';
  String formattedDay = d.day < 10 ? '0${d.day}' : '${d.day}';
  return '${d.year}-$formattedMonth-$formattedDay';
}

String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  String twoDigitHours = twoDigits(duration.inHours.remainder(24));
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return '$twoDigitHours H : $twoDigitMinutes min : $twoDigitSeconds s';
}

String getWeekDayAbbreviation(int weekDay) {
  switch (weekDay) {
    case DateTime.monday:
      return 'Mon';
    case DateTime.tuesday:
      return 'Tue';
    case DateTime.wednesday:
      return 'Wed';
    case DateTime.thursday:
      return 'Thu';
    case DateTime.friday:
      return 'Fri';
    case DateTime.saturday:
      return 'Sat';
    case DateTime.sunday:
      return 'Sun';
    default:
      return '';
  }
}

String getLightCondition(double luxValue) {
  String lightCondition = 'Unknown';
  if (luxValue >= 50000) {
    lightCondition = 'British Summer sunshine';
  } else if (luxValue >= 10000 && luxValue < 50000) {
    lightCondition = 'Ambient Daylight';
  } else if (luxValue >= 1000 && luxValue < 10000) {
    lightCondition = 'Overcast daylight';
  } else if (luxValue >= 500 && luxValue < 1000) {
    lightCondition = 'Well lit office';
  } else if (luxValue >= 400 && luxValue < 500) {
    lightCondition = 'Sunset & Sunrise';
  } else if (luxValue >= 120 && luxValue < 400) {
    lightCondition = 'Family living room';
  } else if (luxValue >= 100 && luxValue < 120) {
    lightCondition = 'Lifts';
  } else if (luxValue >= 15 && luxValue < 100) {
    lightCondition = 'Street lightning';
  } else if (luxValue >= 1 && luxValue < 15) {
    lightCondition = 'Moonlight (full moon)';
  } else if (luxValue >= 0.1 && luxValue < 1) {
    lightCondition = 'Night (No moon)';
  } else {
    lightCondition = 'Unknown';
  }
  return lightCondition;
}
