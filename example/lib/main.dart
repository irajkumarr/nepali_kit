import 'package:flutter/material.dart';
import 'package:nepali_kit/nepali_kit.dart';

void main() {
  runApp(const NepaliKitExampleApp());
}

class NepaliKitExampleApp extends StatefulWidget {
  const NepaliKitExampleApp({super.key});

  @override
  State<NepaliKitExampleApp> createState() => _NepaliKitExampleAppState();
}

class _NepaliKitExampleAppState extends State<NepaliKitExampleApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nepali Kit Showcase',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE65100), // Rich Nepali Ochre/Vermilion
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE65100),
          brightness: Brightness.dark,
        ),
      ),
      home: ShowcaseCatalogScreen(
        isDark: _themeMode == ThemeMode.dark,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

/// Catalog Screen listing all sections requested by the user.
class ShowcaseCatalogScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const ShowcaseCatalogScreen({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  State<ShowcaseCatalogScreen> createState() => _ShowcaseCatalogScreenState();
}

class _ShowcaseCatalogScreenState extends State<ShowcaseCatalogScreen> {
  Language _language = Language.nepali;

  void _toggleLanguage() {
    setState(() {
      _language = _language.isNepali ? Language.english : Language.nepali;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // List of catalog sections in exact order
    final sections = [
      _CatalogItem(
        title: _language.isNepali ? 'आधारभूत पात्रो' : 'Basic Calendar',
        subtitle: _language.isNepali
            ? 'सरल नेपाली क्यालेन्डर र महिना नेभिगेसन'
            : 'Simple Nepali calendar and month navigation',
        icon: Icons.calendar_month,
        badge: 'Core UI',
        builder: (ctx) => BasicCalendarScreen(language: _language),
      ),
      _CatalogItem(
        title: _language.isNepali ? 'मिति रूपान्तरण' : 'Date Conversion',
        subtitle: _language.isNepali
            ? 'वि.सं. ↔ ई.सं. दुई-तर्फी रूपान्तरण'
            : 'Bi-directional BS ↔ AD conversion engine',
        icon: Icons.sync_alt,
        badge: 'Conversion',
        builder: (ctx) => DateConversionScreen(language: _language),
      ),
      _CatalogItem(
        title: _language.isNepali ? 'मिति ढाँचा' : 'Date Formatting',
        subtitle: _language.isNepali
            ? 'ढाँचा ढाँचाहरू (yyyy-MM-dd, नेपाली/अंग्रेजी)'
            : 'Tokens, Devanagari numerals, and dual format',
        icon: Icons.text_format,
        badge: 'Format',
        builder: (ctx) => DateFormattingScreen(language: _language),
      ),
      _CatalogItem(
        title: _language.isNepali ? 'नेपाली अंकहरू' : 'Nepali Numbers',
        subtitle: _language.isNepali
            ? 'देवनागरी अंक, दक्षिण एसियाली अल्पविराम, र शब्दहरू'
            : 'Devanagari digits, South Asian grouping & words',
        icon: Icons.pin,
        badge: 'Numbers',
        builder: (ctx) => NepaliNumbersScreen(language: _language),
      ),
      _CatalogItem(
        title: _language.isNepali ? 'मुद्रा ढाँचा' : 'Currency',
        subtitle: _language.isNepali
            ? 'नेपाली रुपैयाँ (रु / Rs.) ढाँचा र शब्दमा रूपान्तरण'
            : 'Nepali Rupee (NPR) formatting & currency words',
        icon: Icons.payments,
        badge: 'Finance',
        builder: (ctx) => CurrencyScreen(language: _language),
      ),
      _CatalogItem(
        title: _language.isNepali ? 'आर्थिक वर्ष' : 'Fiscal Year',
        subtitle: _language.isNepali
            ? 'नेपाल सरकार आर्थिक वर्ष र त्रैमासिक (Q1-Q4)'
            : 'Nepal Government Fiscal Year (Shrawan 1 - Ashadh end)',
        icon: Icons.account_balance,
        badge: 'Fiscal',
        builder: (ctx) => FiscalYearScreen(language: _language),
      ),
      _CatalogItem(
        title: _language.isNepali ? 'चाडपर्व तथा बिदा' : 'Holidays',
        subtitle: _language.isNepali
            ? 'राष्ट्रिय सार्वजनिक बिदा, दसैं, तिहार, आदि'
            : 'National gazetted holidays & festival lookup',
        icon: Icons.celebration,
        badge: 'Holidays',
        builder: (ctx) => HolidaysScreen(language: _language),
      ),
      _CatalogItem(
        title: _language.isNepali ? 'वि.सं. क्यालेन्डर' : 'BS Calendar',
        subtitle: _language.isNepali
            ? 'विक्रम संवत् पात्रो (३०/३१/३२ दिनको यथार्थ महिना)'
            : 'Bikram Sambat calendar with true dynamic month days',
        icon: Icons.event,
        badge: 'Calendar',
        builder: (ctx) => BsCalendarScreen(language: _language),
      ),
      _CatalogItem(
        title: _language.isNepali ? 'ई.सं. क्यालेन्डर' : 'AD Calendar',
        subtitle: _language.isNepali
            ? 'ग्रेगोरियन क्यालेन्डर (नेपाली भाषा वा अंग्रेजी)'
            : 'Gregorian calendar view with full styling parity',
        icon: Icons.date_range,
        badge: 'Calendar',
        builder: (ctx) => AdCalendarScreen(language: _language),
      ),
      _CatalogItem(
        title: _language.isNepali
            ? 'वि.सं. + ई.सं. संयुक्त पात्रो'
            : 'BS + AD Dual Calendar',
        subtitle: _language.isNepali
            ? 'एउटै बाकसमा दुवै मिति एकसाथ प्रदर्शन'
            : 'Simultaneous BS and AD date display per cell',
        icon: Icons.layers,
        badge: 'Dual View',
        builder: (ctx) => DualCalendarScreen(language: _language),
      ),
      _CatalogItem(
        title: _language.isNepali ? 'मिति चयनकर्ता' : 'Date Picker',
        subtitle: _language.isNepali
            ? 'शो नेपाली डेट पिकर (Material 3 डाइलग)'
            : 'showNepaliDatePicker dialog & bottom picker',
        icon: Icons.edit_calendar,
        badge: 'Picker',
        builder: (ctx) => DatePickerScreen(language: _language),
      ),
      _CatalogItem(
        title: _language.isNepali ? 'दायरा चयनकर्ता' : 'Date Range Picker',
        subtitle: _language.isNepali
            ? 'सुरु र अन्त्य मिति दायरा चयन'
            : 'showNepaliDateRangePicker with day spans',
        icon: Icons.date_range_outlined,
        badge: 'Picker',
        builder: (ctx) => DateRangePickerScreen(language: _language),
      ),
      _CatalogItem(
        title: _language.isNepali ? 'महिना चयनकर्ता' : 'Month Picker',
        subtitle: _language.isNepali
            ? 'बैशाखदेखि चैतसम्मका १२ महिनाहरूको इनलाइन ग्रिड'
            : 'Inline 12-month picker widget (Baisakh-Chaitra)',
        icon: Icons.view_module,
        badge: 'Widget',
        builder: (ctx) => MonthPickerScreen(language: _language),
      ),
      _CatalogItem(
        title: _language.isNepali ? 'वर्ष चयनकर्ता' : 'Year Picker',
        subtitle: _language.isNepali
            ? '१९७५ देखि २०९९ सम्म वर्ष चयन'
            : 'Standalone year selector widget (1975-2099 BS)',
        icon: Icons.calendar_view_month,
        badge: 'Widget',
        builder: (ctx) => YearPickerScreen(language: _language),
      ),
      _CatalogItem(
        title: _language.isNepali ? 'घटना तथा कार्यक्रम' : 'Events',
        subtitle: _language.isNepali
            ? 'एकै दिनमा बहु-कार्यक्रम, बिन्दु सूचक र विवरण'
            : 'Multi-events per date with custom category colors',
        icon: Icons.bookmark,
        badge: 'Events',
        builder: (ctx) => EventsScreen(language: _language),
      ),
      _CatalogItem(
        title: _language.isNepali ? 'निष्क्रिय मितिहरू' : 'Disabled Dates',
        subtitle: _language.isNepali
            ? 'शनिबार, विगतका दिन, वा सर्त अनुसार चयन रोक्ने'
            : 'Selectable day predicates, weekends & bound limits',
        icon: Icons.block,
        badge: 'Predicate',
        builder: (ctx) => DisabledDatesScreen(language: _language),
      ),
      _CatalogItem(
        title: _language.isNepali ? 'कस्टम डे बिल्डर' : 'Custom Day Builder',
        subtitle: _language.isNepali
            ? 'आफ्नै अनुकूल डिजाइन र सेल रेन्डरर'
            : 'Full custom rendering for calendar day cells',
        icon: Icons.brush,
        badge: 'UI Custom',
        builder: (ctx) => CustomDayBuilderScreen(language: _language),
      ),
      _CatalogItem(
        title: _language.isNepali ? 'सापेक्ष समय' : 'Relative Time',
        subtitle: _language.isNepali
            ? 'नेपाली मोमेन्ट ("भर्खरै", "३ दिन अगाडि", "भोलि")'
            : 'NepaliMoment relative timestamps & human moments',
        icon: Icons.update,
        badge: 'Moment',
        builder: (ctx) => RelativeTimeScreen(language: _language),
      ),
      _CatalogItem(
        title:
            _language.isNepali ? 'युनिकोड तथा पाठ' : 'Text / Unicode Utilities',
        subtitle: _language.isNepali
            ? 'अंक पत्ता लगाउने, युनिकोड रूपान्तरण, र देवनागरी'
            : 'Devanagari digit detection, transliteration & cleaners',
        icon: Icons.spellcheck,
        badge: 'Unicode',
        builder: (ctx) => TextUnicodeScreen(language: _language),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _language.isNepali
              ? 'नेपाली किट (nepali_kit)'
              : 'Nepali Kit Showcase',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: _language.isNepali ? 'English' : 'नेपाली',
            icon: CircleAvatar(
              radius: 14,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                _language.isNepali ? 'EN' : 'ने',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            onPressed: _toggleLanguage,
          ),
          IconButton(
            tooltip: widget.isDark ? 'Light Mode' : 'Dark Mode',
            icon: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Header hero banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.auto_stories,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _language.isNepali
                                ? 'नेपाली किट प्रदर्शनी (nepali_kit_example)'
                                : 'Nepali Kit Showcase (v1.0.0)',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _language.isNepali
                                ? '१९ वटै मोड्युल तथा फिचरहरूको विस्तृत डेमो'
                                : 'All 19 Modules & Interactive Feature Demos',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _buildPill(
                      Icons.calendar_today,
                      _language.isNepali
                          ? 'आज: ${const NepaliDateFormat("yyyy MMMM dd, EEEE", Language.nepali).format(NepaliDate.now())}'
                          : 'Today: ${const NepaliDateFormat("yyyy MMMM dd, EEEE", Language.english).format(NepaliDate.now())}',
                    ),
                    _buildPill(
                      Icons.account_balance,
                      _language.isNepali
                          ? 'आ.व.: ${NepaliFiscalYear.current().label}'
                          : 'FY: ${NepaliFiscalYear.current().labelEnglish}',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Text(
            _language.isNepali ? 'मोड्युल तथा फिचरहरू' : 'Catalog of Features',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          ...sections.map((sec) {
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              elevation: 0.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(
                  color:
                      theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                leading: CircleAvatar(
                  radius: 22,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Icon(
                    sec.icon,
                    color: theme.colorScheme.onPrimaryContainer,
                    size: 22,
                  ),
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        sec.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        sec.badge,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    sec.subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: sec.builder),
                  );
                },
              ),
            );
          }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPill(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _CatalogItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final String badge;
  final WidgetBuilder builder;

  _CatalogItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.badge,
    required this.builder,
  });
}

// ============================================================================
// 1. BASIC CALENDAR SCREEN
// ============================================================================
class BasicCalendarScreen extends StatefulWidget {
  final Language language;
  const BasicCalendarScreen({super.key, required this.language});

  @override
  State<BasicCalendarScreen> createState() => _BasicCalendarScreenState();
}

class _BasicCalendarScreenState extends State<BasicCalendarScreen> {
  late NepaliDate _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = NepaliDate.now();
  }

  @override
  Widget build(BuildContext context) {
    final daysInCurrentMonth =
        BsCalendarData.getDaysInMonth(_selectedDate.year, _selectedDate.month);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.language.isNepali
            ? 'आधारभूत पात्रो (Basic Calendar)'
            : 'Basic Calendar'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          NepaliCalendarView(
            selectedDate: _selectedDate,
            language: widget.language,
            onDateSelected: (date) {
              setState(() => _selectedDate = date);
            },
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.language.isNepali
                        ? 'छानिएको मिति जानकारी'
                        : 'Selected Date Information',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  _infoRow(
                    widget.language.isNepali ? 'वि.सं. मिति' : 'BS Date',
                    NepaliDateFormat('yyyy MMMM dd, EEEE', widget.language)
                        .format(_selectedDate),
                  ),
                  _infoRow(
                    widget.language.isNepali ? 'ई.सं. मिति' : 'AD Date',
                    _selectedDate
                        .toDateTime()
                        .toIso8601String()
                        .substring(0, 10),
                  ),
                  _infoRow(
                    widget.language.isNepali
                        ? 'महिनाको कुल दिन'
                        : 'Days in Month',
                    widget.language.isNepali
                        ? '${NepaliDigits.toNepali(daysInCurrentMonth)} दिन'
                        : '$daysInCurrentMonth days',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 2. DATE CONVERSION SCREEN
// ============================================================================
class DateConversionScreen extends StatefulWidget {
  final Language language;
  const DateConversionScreen({super.key, required this.language});

  @override
  State<DateConversionScreen> createState() => _DateConversionScreenState();
}

class _DateConversionScreenState extends State<DateConversionScreen> {
  NepaliDate _bsDate = NepaliDate(2082, 6, 31); // Ashwin 31, 2082
  late DateTime _adDate;

  @override
  void initState() {
    super.initState();
    _adDate = _bsDate.toDateTime();
  }

  void _onAdChanged(DateTime newAd) {
    setState(() {
      _adDate = newAd;
      _bsDate = NepaliDate.fromDateTime(newAd);
    });
  }

  void _onBsChanged(NepaliDate newBs) {
    setState(() {
      _bsDate = newBs;
      _adDate = newBs.toDateTime();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.language.isNepali
            ? 'मिति रूपान्तरण (Date Conversion)'
            : 'Date Conversion'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.sync_alt, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text(
                        widget.language.isNepali
                            ? 'द्वि-दिशात्मक परिशुद्ध रूपान्तरण'
                            : 'Bi-directional Pure Conversion',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.language.isNepali
                        ? 'वि.सं. बाट ई.सं. र ई.सं. बाट वि.सं. गणितीय शुद्धताका साथ।'
                        : 'Accurate BS ↔ AD conversion with zero loss.',
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // BS Section
          Card(
            child: ListTile(
              title: Text(
                widget.language.isNepali
                    ? 'विक्रम संवत् (BS)'
                    : 'Bikram Sambat (BS)',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                NepaliDateFormat('yyyy MMMM dd, EEEE', widget.language)
                    .format(_bsDate),
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              trailing: ElevatedButton(
                onPressed: () async {
                  final picked = await showNepaliDatePicker(
                    context: context,
                    initialDate: _bsDate,
                    language: widget.language,
                  );
                  if (picked != null) _onBsChanged(picked);
                },
                child: Text(widget.language.isNepali ? 'परिवर्तन' : 'Pick BS'),
              ),
            ),
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Icon(Icons.swap_vert, size: 32),
            ),
          ),
          // AD Section
          Card(
            child: ListTile(
              title: Text(
                widget.language.isNepali
                    ? 'ईस्वी संवत् (AD)'
                    : 'Gregorian (AD)',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${_adDate.year}-${_adDate.month.toString().padLeft(2, "0")}-${_adDate.day.toString().padLeft(2, "0")}',
                style: TextStyle(
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              trailing: ElevatedButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _adDate,
                    firstDate: DateTime(1918),
                    lastDate: DateTime(2043),
                  );
                  if (picked != null) _onAdChanged(picked);
                },
                child: Text(widget.language.isNepali ? 'परिवर्तन' : 'Pick AD'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 3. DATE FORMATTING SCREEN
// ============================================================================
class DateFormattingScreen extends StatelessWidget {
  final Language language;
  const DateFormattingScreen({super.key, required this.language});

  @override
  Widget build(BuildContext context) {
    final now = NepaliDateTime.now();
    final patterns = [
      'yyyy-MM-dd',
      'yyyy/MM/dd',
      'dd MMMM yyyy',
      'yyyy MMMM dd, EEEE',
      'EEEE, MMMM dd, yyyy',
      'hh:mm a',
      'yyyy-MM-dd hh:mm:ss a',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(language.isNepali
            ? 'मिति ढाँचा (Date Formatting)'
            : 'Date Formatting'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language.isNepali
                        ? 'नेपाली देवनागरी ढाँचाहरू'
                        : 'Nepali Devanagari Patterns',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  ...patterns.map((p) {
                    final formatted =
                        NepaliDateFormat(p, Language.nepali).format(now);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(p,
                              style: const TextStyle(
                                  fontFamily: 'monospace', fontSize: 13)),
                          Flexible(
                            child: Text(
                              formatted,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language.isNepali
                        ? 'अंग्रेजी ट्रान्सलिटरेसन ढाँचाहरू'
                        : 'English Transliteration Patterns',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  ...patterns.map((p) {
                    final formatted =
                        NepaliDateFormat(p, Language.english).format(now);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(p,
                              style: const TextStyle(
                                  fontFamily: 'monospace', fontSize: 13)),
                          Text(formatted,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 4. NEPALI NUMBERS SCREEN
// ============================================================================
class NepaliNumbersScreen extends StatefulWidget {
  final Language language;
  const NepaliNumbersScreen({super.key, required this.language});

  @override
  State<NepaliNumbersScreen> createState() => _NepaliNumbersScreenState();
}

class _NepaliNumbersScreenState extends State<NepaliNumbersScreen> {
  double _number = 1234567.89;

  @override
  Widget build(BuildContext context) {
    final nepaliDigits = NepaliDigits.toNepali(_number.toInt());
    final nepaliFormatted =
        NepaliNumberFormat.format(_number, language: Language.nepali);
    final englishFormatted =
        NepaliNumberFormat.format(_number, language: Language.english);
    final words =
        NepaliNumberToWords.convert(_number, language: Language.nepali);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.language.isNepali
            ? 'नेपाली अंकहरू (Nepali Numbers)'
            : 'Nepali Numbers'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.language.isNepali
                        ? 'अंक परिवर्तन गर्नुहोस्'
                        : 'Adjust Number',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: _number,
                    min: 0,
                    max: 10000000,
                    divisions: 100,
                    onChanged: (v) => setState(() => _number = v),
                  ),
                  _infoRow(
                    widget.language.isNepali ? 'कच्चा मान (Raw)' : 'Raw Value',
                    _number.toStringAsFixed(2),
                  ),
                  _infoRow(
                    widget.language.isNepali
                        ? 'देवनागरी अंक (०-९)'
                        : 'Devanagari Digits',
                    nepaliDigits,
                  ),
                  _infoRow(
                    widget.language.isNepali
                        ? 'दक्षिण एसियाली अल्पविराम (नेपाली)'
                        : 'Nepali Grouping',
                    nepaliFormatted,
                  ),
                  _infoRow(
                    widget.language.isNepali
                        ? 'दक्षिण एसियाली अल्पविराम (अंग्रेजी)'
                        : 'English Grouping',
                    englishFormatted,
                  ),
                  _infoRow(
                    widget.language.isNepali
                        ? 'नेपाली अक्षरमा (In Words)'
                        : 'In Words',
                    words,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 5. CURRENCY SCREEN
// ============================================================================
class CurrencyScreen extends StatefulWidget {
  final Language language;
  const CurrencyScreen({super.key, required this.language});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  double _amount = 85450.50;

  @override
  Widget build(BuildContext context) {
    final nepaliCurrency =
        NepaliNumberFormat.currency(_amount, language: Language.nepali);
    final englishCurrency =
        NepaliNumberFormat.currency(_amount, language: Language.english);
    final words =
        NepaliNumberToWords.convert(_amount, language: Language.nepali);

    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.language.isNepali ? 'मुद्रा ढाँचा (Currency)' : 'Currency'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.language.isNepali
                        ? 'रकम परिवर्तन गर्नुहोस्'
                        : 'Adjust Amount',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: _amount,
                    min: 100,
                    max: 1000000,
                    divisions: 100,
                    onChanged: (v) => setState(() => _amount = v),
                  ),
                  _infoRow(
                    widget.language.isNepali
                        ? 'नेपाली मुद्रा ढाँचा'
                        : 'Nepali Currency',
                    nepaliCurrency,
                  ),
                  _infoRow(
                    widget.language.isNepali
                        ? 'अंग्रेजी मुद्रा ढाँचा'
                        : 'English Currency',
                    englishCurrency,
                  ),
                  _infoRow(
                    widget.language.isNepali
                        ? 'रकम अक्षरमा (चेक/बिल प्रयोजन)'
                        : 'Words for Invoice/Cheque',
                    '$words रुपैयाँ मात्र',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 6. FISCAL YEAR SCREEN
// ============================================================================
class FiscalYearScreen extends StatelessWidget {
  final Language language;
  const FiscalYearScreen({super.key, required this.language});

  @override
  Widget build(BuildContext context) {
    final fy = NepaliFiscalYear.current();
    final quarters = fy.quarters;

    return Scaffold(
      appBar: AppBar(
        title: Text(language.isNepali
            ? 'आर्थिक वर्ष (Fiscal Year)'
            : 'Nepali Fiscal Year'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language.isNepali
                        ? 'नेपाल सरकार आर्थिक वर्ष: ${fy.label}'
                        : 'Government of Nepal FY: ${fy.labelEnglish}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Divider(),
                  _infoRow(
                    language.isNepali ? 'सुरु मिति' : 'Start Date',
                    '${NepaliDateFormat("yyyy-MM-dd", language).format(fy.startDate)} (${fy.adStartDate.toIso8601String().substring(0, 10)})',
                  ),
                  _infoRow(
                    language.isNepali ? 'अन्त्य मिति' : 'End Date',
                    '${NepaliDateFormat("yyyy-MM-dd", language).format(fy.endDate)} (${fy.adEndDate.toIso8601String().substring(0, 10)})',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            language.isNepali
                ? 'त्रैमासिक विभाजन (Quarters)'
                : 'Quarterly Breakdown (Q1 - Q4)',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          ...quarters.map((q) {
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(
                  q.quarter.getName(language),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${NepaliDateFormat("yyyy MMMM dd", language).format(q.startDate)} - ${NepaliDateFormat("yyyy MMMM dd", language).format(q.endDate)}',
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ============================================================================
// 7. HOLIDAYS SCREEN
// ============================================================================
class HolidaysScreen extends StatelessWidget {
  final Language language;
  const HolidaysScreen({super.key, required this.language});

  @override
  Widget build(BuildContext context) {
    final holidays = NepaliHolidayService.holidaysForYear(2082);

    return Scaffold(
      appBar: AppBar(
        title: Text(language.isNepali
            ? 'चाडपर्व तथा बिदा (Holidays)'
            : 'Holidays & Festivals'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            language.isNepali
                ? '२०८२ सालका प्रमुख सार्वजनिक बिदाहरू'
                : 'Key Gazetted Holidays (2082 BS)',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          ...holidays.map((h) {
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: h.isPublicHoliday
                      ? Colors.red.withValues(alpha: 0.15)
                      : Colors.orange.withValues(alpha: 0.15),
                  child: Icon(
                    Icons.celebration,
                    color: h.isPublicHoliday ? Colors.red : Colors.orange,
                  ),
                ),
                title: Text(
                  h.getName(language),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  NepaliDateFormat('yyyy MMMM dd, EEEE', language)
                      .format(h.date),
                ),
                trailing: h.isPublicHoliday
                    ? Chip(
                        label: Text(
                          language.isNepali ? 'सार्वजनिक' : 'Public',
                          style: const TextStyle(fontSize: 10),
                        ),
                        backgroundColor: Colors.red.withValues(alpha: 0.1),
                      )
                    : null,
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ============================================================================
// 8. BS CALENDAR SCREEN
// ============================================================================
class BsCalendarScreen extends StatefulWidget {
  final Language language;
  const BsCalendarScreen({super.key, required this.language});

  @override
  State<BsCalendarScreen> createState() => _BsCalendarScreenState();
}

class _BsCalendarScreenState extends State<BsCalendarScreen> {
  late NepaliDate _date;

  @override
  void initState() {
    super.initState();
    // Default to Ashwin 2082 to demonstrate 31 days month
    _date = NepaliDate(2082, 6, 15);
  }

  @override
  Widget build(BuildContext context) {
    final daysCount = BsCalendarData.getDaysInMonth(_date.year, _date.month);
    final monthName = _date.nepaliMonth.getName(widget.language);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.language.isNepali
            ? 'वि.सं. पात्रो (BS Calendar)'
            : 'BS Calendar (Bikram Sambat)'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          NepaliCalendarView(
            selectedDate: _date,
            initialDate: _date,
            language: widget.language,
            onDateSelected: (d) => setState(() => _date = d),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.blue),
              title: Text(
                widget.language.isNepali
                    ? 'यथार्थ महिनाको दिन संख्या'
                    : 'Actual Days in This Month',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                widget.language.isNepali
                    ? '${_date.year} सालको $monthName महिनामा ${NepaliDigits.toNepali(daysCount)} दिनहरू छन्।'
                    : '$monthName ${_date.year} has $daysCount days in Bikram Sambat.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 9. AD CALENDAR SCREEN
// ============================================================================
class AdCalendarScreen extends StatefulWidget {
  final Language language;
  const AdCalendarScreen({super.key, required this.language});

  @override
  State<AdCalendarScreen> createState() => _AdCalendarScreenState();
}

class _AdCalendarScreenState extends State<AdCalendarScreen> {
  DateTime _adDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.language.isNepali
            ? 'ई.सं. क्यालेन्डर (AD Calendar)'
            : 'AD Calendar (Gregorian)'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ADCalendarView(
            selectedDate: _adDate,
            language: widget.language,
            onDateSelected: (d) => setState(() => _adDate = d),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              title: Text(
                widget.language.isNepali ? 'छानिएको मिति' : 'Selected Date',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${_adDate.year}-${_adDate.month.toString().padLeft(2, '0')}-${_adDate.day.toString().padLeft(2, '0')}',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 10. BS + AD DUAL CALENDAR SCREEN
// ============================================================================
class DualCalendarScreen extends StatefulWidget {
  final Language language;
  const DualCalendarScreen({super.key, required this.language});

  @override
  State<DualCalendarScreen> createState() => _DualCalendarScreenState();
}

class _DualCalendarScreenState extends State<DualCalendarScreen> {
  late NepaliDate _date;

  @override
  void initState() {
    super.initState();
    _date = NepaliDate.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.language.isNepali
            ? 'संयुक्त पात्रो (BS + AD Dual)'
            : 'BS + AD Dual Calendar'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          NepaliCalendarView(
            selectedDate: _date,
            showDualDate: true,
            language: widget.language,
            onDateSelected: (d) => setState(() => _date = d),
          ),
          const SizedBox(height: 16),
          DualDateDisplay(
            nepaliDate: _date.toNepaliDateTime(),
            language: widget.language,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 11. DATE PICKER SCREEN
// ============================================================================
class DatePickerScreen extends StatefulWidget {
  final Language language;
  const DatePickerScreen({super.key, required this.language});

  @override
  State<DatePickerScreen> createState() => _DatePickerScreenState();
}

class _DatePickerScreenState extends State<DatePickerScreen> {
  NepaliDate? _pickedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.language.isNepali
            ? 'मिति चयनकर्ता (Date Picker)'
            : 'Date Picker Dialog'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _pickedDate != null
                    ? NepaliDateFormat('yyyy MMMM dd, EEEE', widget.language)
                        .format(_pickedDate!)
                    : (widget.language.isNepali
                        ? 'कुनै मिति छानिएको छैन'
                        : 'No date selected yet'),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.date_range),
                label: Text(widget.language.isNepali
                    ? 'मिति छान्नुहोस् (Open Picker)'
                    : 'Open Nepali Date Picker'),
                onPressed: () async {
                  final picked = await showNepaliDatePicker(
                    context: context,
                    initialDate: _pickedDate ?? NepaliDate.now(),
                    language: widget.language,
                  );
                  if (picked != null) {
                    setState(() => _pickedDate = picked);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 12. DATE RANGE PICKER SCREEN
// ============================================================================
class DateRangePickerScreen extends StatefulWidget {
  final Language language;
  const DateRangePickerScreen({super.key, required this.language});

  @override
  State<DateRangePickerScreen> createState() => _DateRangePickerScreenState();
}

class _DateRangePickerScreenState extends State<DateRangePickerScreen> {
  NepaliDateRange? _range;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.language.isNepali
            ? 'दायरा चयनकर्ता (Date Range Picker)'
            : 'Date Range Picker'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_range != null) ...[
                Text(
                  '${_range!.startDate.format("yyyy-MM-dd")}  ➔  ${_range!.endDate.format("yyyy-MM-dd")}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.language.isNepali
                      ? 'जम्मा ${_range!.inDays} दिन'
                      : 'Total ${_range!.inDays} days',
                  style: const TextStyle(color: Colors.grey),
                ),
              ] else
                Text(
                  widget.language.isNepali
                      ? 'कुनै दायरा छानिएको छैन'
                      : 'No date range selected',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.calendar_view_day),
                label: Text(widget.language.isNepali
                    ? 'दायरा छान्नुहोस्'
                    : 'Select Date Range'),
                onPressed: () async {
                  final picked = await showNepaliDateRangePicker(
                    context: context,
                    initialDateRange: _range,
                    language: widget.language,
                  );
                  if (picked != null) {
                    setState(() => _range = picked);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 13. MONTH PICKER SCREEN
// ============================================================================
class MonthPickerScreen extends StatefulWidget {
  final Language language;
  const MonthPickerScreen({super.key, required this.language});

  @override
  State<MonthPickerScreen> createState() => _MonthPickerScreenState();
}

class _MonthPickerScreenState extends State<MonthPickerScreen> {
  int _selectedMonth = 6; // Ashwin

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.language.isNepali
            ? 'महिना चयनकर्ता (Month Picker)'
            : 'Month Picker Widget'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              widget.language.isNepali
                  ? 'छानिएको महिना: ${NepaliMonth.fromIndex(_selectedMonth).nameNepali}'
                  : 'Selected Month: ${NepaliMonth.fromIndex(_selectedMonth).nameEnglish}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            NepaliMonthPicker(
              selectedMonth: _selectedMonth,
              language: widget.language,
              onMonthSelected: (m) => setState(() => _selectedMonth = m),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// 14. YEAR PICKER SCREEN
// ============================================================================
class YearPickerScreen extends StatefulWidget {
  final Language language;
  const YearPickerScreen({super.key, required this.language});

  @override
  State<YearPickerScreen> createState() => _YearPickerScreenState();
}

class _YearPickerScreenState extends State<YearPickerScreen> {
  int _selectedYear = 2082;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.language.isNepali
            ? 'वर्ष चयनकर्ता (Year Picker)'
            : 'Year Picker Widget'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              widget.language.isNepali
                  ? 'छानिएको वर्ष: ${NepaliDigits.toNepali(_selectedYear)} वि.सं.'
                  : 'Selected Year: $_selectedYear BS',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: NepaliYearPicker(
              selectedYear: _selectedYear,
              language: widget.language,
              onYearSelected: (y) => setState(() => _selectedYear = y),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 15. EVENTS SCREEN
// ============================================================================
class EventsScreen extends StatefulWidget {
  final Language language;
  const EventsScreen({super.key, required this.language});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  late NepaliDate _selectedDate;
  late Map<NepaliDate, List<CalendarEvent>> _events;

  @override
  void initState() {
    super.initState();
    _selectedDate = NepaliDate(2082, 7, 5);
    _events = {
      NepaliDate(2082, 7, 5): [
        CalendarEvent(
          id: 'event_dashain',
          date: NepaliDate(2082, 7, 5),
          title: 'Dashain Festival (दशैं पर्व)',
          type: CalendarEventType.personal,
          colorValue: 0xFFF44336, // Red
        ),
        CalendarEvent(
          id: 'event_tika',
          date: NepaliDate(2082, 7, 5),
          title: 'Family Gathering & Tika',
          type: CalendarEventType.personal,
          colorValue: 0xFF2196F3, // Blue
        ),
      ],
      NepaliDate(2082, 7, 10): [
        CalendarEvent(
          id: 'event_project_deadline',
          date: NepaliDate(2082, 7, 10),
          title: 'Project Milestone Deadline',
          type: CalendarEventType.work,
          colorValue: 0xFF9C27B0, // Purple
        ),
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    final dayEvents = _events[_selectedDate] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.language.isNepali
            ? 'कार्यक्रम तथा इभेन्ट (Events)'
            : 'Calendar Events'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          NepaliCalendarView(
            selectedDate: _selectedDate,
            initialDate: _selectedDate,
            events: _events,
            language: widget.language,
            onDateSelected: (d) => setState(() => _selectedDate = d),
          ),
          const SizedBox(height: 16),
          Text(
            widget.language.isNepali
                ? 'कार्यक्रम सूची (${dayEvents.length})'
                : 'Events on this Day (${dayEvents.length})',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          if (dayEvents.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  widget.language.isNepali
                      ? 'यस दिन कुनै कार्यक्रम छैन।'
                      : 'No events scheduled for this date.',
                ),
              ),
            )
          else
            ...dayEvents.map((e) {
              final color =
                  e.colorValue != null ? Color(e.colorValue!) : Colors.orange;
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: color,
                    radius: 6,
                  ),
                  title: Text(e.title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(e.type.name),
                ),
              );
            }),
        ],
      ),
    );
  }
}

// ============================================================================
// 16. DISABLED DATES SCREEN
// ============================================================================
class DisabledDatesScreen extends StatefulWidget {
  final Language language;
  const DisabledDatesScreen({super.key, required this.language});

  @override
  State<DisabledDatesScreen> createState() => _DisabledDatesScreenState();
}

class _DisabledDatesScreenState extends State<DisabledDatesScreen> {
  NepaliDate? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.language.isNepali
            ? 'निष्क्रिय मितिहरू (Disabled Dates)'
            : 'Disabled Dates Predicate'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: Colors.amber.withValues(alpha: 0.12),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                widget.language.isNepali
                    ? 'यस क्यालेन्डरमा शनिबार (शनि) र २५ गते पछिका दिनहरू चयन गर्न मिल्दैन।'
                    : 'Saturdays and days after day 25 are disabled using selectableDayPredicate.',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 12),
          NepaliCalendarView(
            selectedDate: _selected,
            language: widget.language,
            selectableDayPredicate: (date) {
              // Disable Saturday and days after 25
              if (date.nepaliWeekday == NepaliWeekday.saturday) return false;
              if (date.day > 25) return false;
              return true;
            },
            onDateSelected: (d) => setState(() => _selected = d),
          ),
          const SizedBox(height: 16),
          if (_selected != null)
            Card(
              child: ListTile(
                title: Text(
                  widget.language.isNepali
                      ? 'छानिएको स्वीकृत मिति'
                      : 'Selected Allowed Date',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  NepaliDateFormat('yyyy-MM-dd, EEEE', widget.language)
                      .format(_selected!),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ============================================================================
// 17. CUSTOM DAY BUILDER SCREEN
// ============================================================================
class CustomDayBuilderScreen extends StatefulWidget {
  final Language language;
  const CustomDayBuilderScreen({super.key, required this.language});

  @override
  State<CustomDayBuilderScreen> createState() => _CustomDayBuilderScreenState();
}

class _CustomDayBuilderScreenState extends State<CustomDayBuilderScreen> {
  NepaliDate _selected = NepaliDate.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.language.isNepali
            ? 'कस्टम डे बिल्डर (Custom Day Builder)'
            : 'Custom Day Builder'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          NepaliCalendarView(
            selectedDate: _selected,
            language: widget.language,
            onDateSelected: (d) => setState(() => _selected = d),
            dayBuilder: (context, date,
                {required isDisabled,
                required isHoliday,
                required isSelected,
                required isToday,
                required hasEvents,
                events = const []}) {
              // Custom rendering: gradient for selected, round badge for today
              if (isSelected) {
                return Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.purple, Colors.deepOrange],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    widget.language.isNepali
                        ? NepaliDigits.toNepali(date.day)
                        : '${date.day}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
              if (isToday) {
                return Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.purple, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    widget.language.isNepali
                        ? NepaliDigits.toNepali(date.day)
                        : '${date.day}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              }
              return null; // fallback to default
            },
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 18. RELATIVE TIME SCREEN
// ============================================================================
class RelativeTimeScreen extends StatelessWidget {
  final Language language;
  const RelativeTimeScreen({super.key, required this.language});

  @override
  Widget build(BuildContext context) {
    final now = NepaliDateTime.now();
    final samples = [
      now.subtract(const Duration(seconds: 40)),
      now.subtract(const Duration(minutes: 15)),
      now.subtract(const Duration(hours: 4)),
      now.subtractDays(1),
      now.subtractDays(3),
      now.subtractDays(45),
      now.add(const Duration(hours: 2)),
      now.addDays(1),
      now.addDays(10),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(language.isNepali
            ? 'सापेक्ष समय (Relative Time)'
            : 'Relative Time Moments'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language.isNepali
                        ? 'नेपाली मोमेन्ट (Nepali Moments)'
                        : 'Human Readable Relative Timestamps',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  ...samples.map((dt) {
                    final np =
                        NepaliMoment.fromDate(dt, language: Language.nepali);
                    final en =
                        NepaliMoment.fromDate(dt, language: Language.english);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(np,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14)),
                          Text(en,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 13)),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 19. TEXT / UNICODE UTILITIES SCREEN
// ============================================================================
class TextUnicodeScreen extends StatefulWidget {
  final Language language;
  const TextUnicodeScreen({super.key, required this.language});

  @override
  State<TextUnicodeScreen> createState() => _TextUnicodeScreenState();
}

class _TextUnicodeScreenState extends State<TextUnicodeScreen> {
  final TextEditingController _romanizedController = TextEditingController(
    text: "sayau' thu''gaa fUlakaa haamii, euTai maalaa nepaalii",
  );
  final TextEditingController _digitController =
      TextEditingController(text: 'मंसिर २०८२ मा ५५ जना मानिस आए।');

  bool _liveConversion = true;

  @override
  void dispose() {
    _romanizedController.dispose();
    _digitController.dispose();
    super.dispose();
  }

  void _loadExample(String example) {
    setState(() {
      _romanizedController.text = example;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNepali = widget.language.isNepali;

    // Romanized transliteration
    final romanizedInput = _romanizedController.text;
    final convertedOutput = NepaliUnicode.convert(
      romanizedInput,
      live: _liveConversion,
    );

    // Digit utilities
    final digitText = _digitController.text;
    final hasNepaliDigits = NepaliDigits.containsNepaliDigits(digitText);
    final toEnglish = NepaliDigits.toEnglish(digitText);
    final toNepali = NepaliDigits.toNepali(toEnglish);

    return Scaffold(
      appBar: AppBar(
        title: Text(isNepali
            ? 'युनिकोड तथा पाठ (Text & Unicode)'
            : 'Text & Unicode Utilities'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Romanized to Nepali Unicode Converter Card
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.translate, color: theme.colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        isNepali
                            ? 'रोमनाइज्ड → नेपाली युनिकोड'
                            : 'Romanized → Nepali Unicode',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isNepali
                        ? 'अंग्रेजी अक्षरमा टाइप गरेर प्रत्यक्ष नेपाली युनिकोड प्राप्त गर्नुहोस्।'
                        : 'Phonetic English literal to clean Devanagari Unicode converter.',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Preset example buttons
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ActionChip(
                          avatar: const Icon(Icons.music_note, size: 16),
                          label: Text(isNepali ? 'गान १' : 'Anthem 1'),
                          onPressed: () => _loadExample(
                            "sayau' thu''gaa fUlakaa haamii, euTai maalaa nepaalii",
                          ),
                        ),
                        const SizedBox(width: 8),
                        ActionChip(
                          avatar: const Icon(Icons.flag, size: 16),
                          label: Text(isNepali ? 'गान २' : 'Anthem 2'),
                          onPressed: () => _loadExample(
                            "saarwabhauma bhai failiekaa, mecii-mahaakaalii",
                          ),
                        ),
                        const SizedBox(width: 8),
                        ActionChip(
                          avatar: const Icon(Icons.handshake, size: 16),
                          label: Text(isNepali ? 'अभिवादन' : 'Greetings'),
                          onPressed: () => _loadExample(
                            "namaste, tpaaii'laaii kasto chha? swagatam!",
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Input text field
                  TextField(
                    controller: _romanizedController,
                    maxLines: 3,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      labelText: isNepali
                          ? 'रोमनाइज्ड नेपाली (Romanized input)'
                          : 'Romanized Nepali Input',
                      hintText: "sayau' thu''gaa fUlakaa haamii...",
                      border: const OutlineInputBorder(),
                      suffixIcon: _romanizedController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _romanizedController.clear();
                                setState(() {});
                              },
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Live conversion toggle
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      isNepali ? 'प्रत्यक्ष रूपान्तरण' : 'Live conversion',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      isNepali
                          ? 'टाइप गर्दागर्दै तत्काल युनिकोड बनाउने'
                          : 'Incremental type-as-you-write conversion',
                      style: const TextStyle(fontSize: 12),
                    ),
                    value: _liveConversion,
                    onChanged: (val) => setState(() => _liveConversion = val),
                  ),
                  const Divider(),
                  const SizedBox(height: 4),
                  // Converted Output Header with Copy Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isNepali
                            ? 'नेपाली युनिकोड नतिजा'
                            : 'Nepali Unicode Result',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.copy, size: 16),
                        label: Text(isNepali ? 'प्रतिलिपि' : 'Copy'),
                        onPressed: convertedOutput.isEmpty
                            ? null
                            : () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isNepali
                                          ? 'क्लिपबोर्डमा प्रतिलिपि गरियो!'
                                          : 'Copied to clipboard!',
                                    ),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Converted Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant,
                      ),
                    ),
                    child: SelectableText(
                      convertedOutput.isEmpty
                          ? (isNepali
                              ? '(कुनै इनपुट छैन)'
                              : '(No input provided)')
                          : convertedOutput,
                      style: TextStyle(
                        fontSize: 15,
                        color: convertedOutput.isEmpty
                            ? theme.colorScheme.outline
                            : theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 2. Nepali Digits & Detection Card
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.pin, color: theme.colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        isNepali
                            ? 'अंक रूपान्तरण तथा पहिचान'
                            : 'Digits & Identification',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isNepali ? 'पाठ प्रविष्टि (Input String)' : 'Input String',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _digitController,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _infoRow(
                    isNepali
                        ? 'नेपाली अंक समावेश छ?'
                        : 'Contains Devanagari Digits?',
                    hasNepaliDigits ? 'Yes (छ)' : 'No (छैन)',
                  ),
                  _infoRow(
                    isNepali
                        ? 'अंग्रेजी अंकमा रूपान्तरण'
                        : 'Converted to ASCII',
                    toEnglish,
                  ),
                  _infoRow(
                    isNepali
                        ? 'देवनागरी अंकमा रूपान्तरण'
                        : 'Converted to Devanagari',
                    toNepali,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// SHARED HELPER WIDGETS
// ============================================================================
Widget _infoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Text(
            value,
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ],
    ),
  );
}
