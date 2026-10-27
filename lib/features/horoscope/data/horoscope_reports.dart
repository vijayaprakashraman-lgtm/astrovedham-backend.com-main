class HoroscopeReport {
  final String title;
  final String pdfUrl;

  const HoroscopeReport({required this.title, required this.pdfUrl});
}

class HoroscopeReports {
  HoroscopeReports._();

  static const List<HoroscopeReport> all = [
    HoroscopeReport(
      title: 'Life Horoscope',
      pdfUrl: 'https://files.msg91.com/456460/erjkjhqg.pdf',
    ),
    HoroscopeReport(
      title: 'Super Life Horoscope',
      pdfUrl: 'https://files.msg91.com/456460/vjhiaifk.pdf',
    ),
    HoroscopeReport(
      title: 'Marriage Horoscope',
      pdfUrl: 'https://files.msg91.com/456460/wojedqeu.pdf',
    ),
    HoroscopeReport(
      title: 'Wealth Horoscope',
      pdfUrl: 'https://files.msg91.com/456460/bfmmelgv.pdf',
    ),
    HoroscopeReport(
      title: 'Yearly Horoscope',
      pdfUrl: 'https://files.msg91.com/456460/wqvwvdjn.pdf',
    ),
    HoroscopeReport(
      title: 'Single Page Horoscope',
      pdfUrl: 'https://files.msg91.com/456460/stkyaxde.pdf',
    ),
    HoroscopeReport(
      title: 'Numerology Horoscope',
      pdfUrl: 'https://files.msg91.com/456460/irmdubzf.pdf',
    ),
    HoroscopeReport(
      title: 'Gemstones Horoscope',
      pdfUrl: 'https://files.msg91.com/456460/germ_horoscope.pdf',
    ),
    HoroscopeReport(
      title: 'Marriage Matching',
      pdfUrl: 'https://files.msg91.com/456460/qtthqils.pdf',
    ),
    HoroscopeReport(
      title: 'Marriage Matching Lite',
      pdfUrl: 'https://files.msg91.com/456460/xzbahqlu.pdf',
    ),
  ];
}
