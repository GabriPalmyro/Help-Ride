String dateFormater(DateTime? date) {
  if (date == null) {
    return 'nenhuma data cadastrada';
  } else {
    String day = date.day.toString();
    String month = date.month.toString();
    String year = date.year.toString();
    return '$day/$month/$year';
  }
}

DateTime dateFormat(String? dateFull) {
  if (dateFull == null || dateFull.isEmpty) {
    return DateTime(1990, 10, 7);
  } else {
    final List<String> dateList = dateFull.split(' ');
    final List dateNumbers = dateList[0].split('/');
    final String date = '${dateNumbers[2]}-${dateNumbers[1]}-${dateNumbers[0]}';
    return DateTime.tryParse(date)!;
  }
}
