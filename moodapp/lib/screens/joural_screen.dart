import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moodapp/constant/constant.dart';
import 'package:moodapp/constant/text_widget.dart';
import 'package:moodapp/database/database_helper.dart';

class JournalScreen extends StatefulWidget {
  final bool isDarkMode;
  const JournalScreen({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadComment();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _saveComment() async {
    final comment = _commentController.text.trim();
    final dateString = _selectedDate.toIso8601String().split('T').first;

    await DatabaseHelper.instance.insertOrUpdateJournal(dateString, comment);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Comment Saved!",
            style: TextStyle(
              color: widget.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          backgroundColor: widget.isDarkMode ? Colors.grey[800] : Colors.white,
        ),
      );
    }
  }

  void _loadComment() async {
    final dateString = _selectedDate.toIso8601String().split('T').first;
    final comment = await DatabaseHelper.instance.getJournalCommentByDate(dateString);

    setState(() {
      _commentController.text = comment ?? '';
    });
  }

  Future<void> _pickDateFromCalendar() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: kPurpleColor,
              onPrimary: Colors.white,
              onSurface: widget.isDarkMode ? Colors.white : Colors.black,
            ),
            dialogBackgroundColor: widget.isDarkMode ? Colors.grey[900] : Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
      _loadComment();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.black : kWhiteColor,
      appBar: AppBar(
        backgroundColor: widget.isDarkMode ? Colors.black : kWhiteColor,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_outlined,
            color: widget.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        title: CustomText(
          'Journal',
          color: widget.isDarkMode ? Colors.white : kBlackColor,
          fontWeight: FontWeight.w600,
          fontSize: 16.sp,
        ),
        actions: [
          IconButton(
            onPressed: _pickDateFromCalendar,
            icon: Icon(
              Icons.calendar_today_outlined,
              color: widget.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.only(top: 10.h),
        decoration: BoxDecoration(
          color: widget.isDarkMode ? Colors.grey[850] : kWhiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.r),
            topRight: Radius.circular(25.r),
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: CustomText(
                  _getMonthName(_selectedDate),
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                  color: widget.isDarkMode ? Colors.white : kBlackColor,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Container(
                  height: 80.h,
                  child: DatePicker(
                    DateTime.now().subtract(const Duration(days: 365)),
                    initialSelectedDate: _selectedDate,
                    selectionColor: kPurpleColor,
                    selectedTextColor: Colors.white,
                    onDateChange: (date) {
                      if (date.isAfter(DateTime.now())) return;
                      setState(() {
                        _selectedDate = date;
                      });
                      _loadComment();
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0.w),
                child: Row(
                  children: [
                    CustomText(
                      'Comment',
                      fontWeight: FontWeight.w500,
                      fontSize: 20.sp,
                      color: widget.isDarkMode ? Colors.white : kBlackColor,
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.edit_note_outlined,
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: TextField(
                  controller: _commentController,
                  minLines: 5,
                  maxLines: 10,
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: widget.isDarkMode ? Colors.white : kBlackColor,
                  ),
                  decoration: InputDecoration(
                    hintText: "Write your thoughts here...",
                    hintStyle: TextStyle(
                      color: widget.isDarkMode ? Colors.white70 : kGreyColor,
                    ),
                    filled: true,
                    fillColor: widget.isDarkMode ? Colors.white10 : kBackgroundColor,
                    contentPadding: EdgeInsets.all(12.r),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
                child: ElevatedButton(
                  onPressed: _saveComment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPurpleColor,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                  ),
                  child: CustomText(
                    'Save Comment',
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMonthName(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[date.month - 1];
  }
}
