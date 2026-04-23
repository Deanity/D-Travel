import 'package:flutter/material.dart';

class BookingDatePicker extends StatefulWidget {
  const BookingDatePicker({super.key});

  @override
  State<BookingDatePicker> createState() => _BookingDatePickerState();
}

class _BookingDatePickerState extends State<BookingDatePicker> {
  DateTime? _startDate;
  DateTime? _endDate;
  int _selectedYear = 2024; // Default to current year for demo

  final List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  void _onDateSelected(DateTime date) {
    setState(() {
      if (_startDate == null || (_startDate != null && _endDate != null)) {
        _startDate = date;
        _endDate = null;
      } else if (date.isBefore(_startDate!)) {
        _startDate = date;
      } else {
        _endDate = date;
      }
    });
  }

  bool _isDateSelected(DateTime date) {
    if (_startDate != null && date.isAtSameMomentAs(_startDate!)) return true;
    if (_endDate != null && date.isAtSameMomentAs(_endDate!)) return true;
    return false;
  }

  bool _isInRange(DateTime date) {
    if (_startDate != null && _endDate != null) {
      return date.isAfter(_startDate!) && date.isBefore(_endDate!);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Choose Booking Date',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          
          // Year Selection
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => setState(() => _selectedYear--),
                  icon: const Icon(Icons.arrow_back_ios, size: 18),
                ),
                Text(
                  '$_selectedYear',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => setState(() => _selectedYear++),
                  icon: const Icon(Icons.arrow_forward_ios, size: 18),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Calendar Body
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: 12,
              itemBuilder: (context, index) {
                return _buildMonthCalendar(index + 1);
              },
            ),
          ),
          
          // Bottom Buttons
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: const Text('Back', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, {'start': _startDate, 'end': _endDate}),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFCD240),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: const Text('Confirm', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthCalendar(int month) {
    DateTime firstDay = DateTime(_selectedYear, month, 1);
    int daysInMonth = DateTime(_selectedYear, month + 1, 0).day;
    int firstWeekday = firstDay.weekday % 7; // 0 for Sunday

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            _months[month - 1],
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        
        // Days of week header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) => 
            SizedBox(
              width: 35,
              child: Text(
                day,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            )
          ).toList(),
        ),
        
        const SizedBox(height: 12),
        
        // Grid of days
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 8,
            crossAxisSpacing: 0,
          ),
          itemCount: daysInMonth + firstWeekday,
          itemBuilder: (context, index) {
            if (index < firstWeekday) return const SizedBox();
            
            int day = index - firstWeekday + 1;
            DateTime date = DateTime(_selectedYear, month, day);
            bool isSelected = _isDateSelected(date);
            bool inRange = _isInRange(date);
            
            return GestureDetector(
              onTap: () => _onDateSelected(date),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (inRange)
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFCD240).withOpacity(0.2),
                      ),
                    ),
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFFCD240) : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$day',
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.black87,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
