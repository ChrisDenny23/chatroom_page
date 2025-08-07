// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, deprecated_member_use, avoid_web_libraries_in_flutter, file_names

import 'package:flutter/material.dart';
import '../widgets/enhanced_header.dart';

class LogsPage extends StatefulWidget {
  final Map<String, dynamic> currentTheme;

  const LogsPage({super.key, required this.currentTheme});

  @override
  _LogsPageState createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> with TickerProviderStateMixin {
  late AnimationController _animationController;

  List<Map<String, dynamic>> logs = [
    {
      'name': 'John Smith',
      'country': 'United States',
      'room': 'General Chat',
      'ipAddress': '192.168.1.101',
      'time': '2024-08-05 14:30:22',
      'entryTime': '2024-08-05 14:30:22',
      'checkoutTime': '2024-08-05 15:45:10',
      'duration': '1h 14m',
      'status': 'Completed',
    },
    {
      'name': 'Maria Garcia',
      'country': 'Spain',
      'room': 'Tech Support',
      'ipAddress': '172.16.0.85',
      'time': '2024-08-05 15:20:15',
      'entryTime': '2024-08-05 15:20:15',
      'checkoutTime': null,
      'duration': 'Active',
      'status': 'Online',
    },
    {
      'name': 'Ahmed Hassan',
      'country': 'Egypt',
      'room': 'General Chat',
      'ipAddress': '198.51.100.55',
      'time': '2024-08-05 13:45:30',
      'entryTime': '2024-08-05 13:45:30',
      'checkoutTime': '2024-08-05 14:20:45',
      'duration': '35m',
      'status': 'Completed',
    },
    {
      'name': 'Lisa Chen',
      'country': 'China',
      'room': 'Gaming Zone',
      'ipAddress': '10.0.0.95',
      'time': '2024-08-05 16:10:05',
      'entryTime': '2024-08-05 16:10:05',
      'checkoutTime': null,
      'duration': 'Active',
      'status': 'Online',
    },
    {
      'name': 'Robert Johnson',
      'country': 'Canada',
      'room': 'Tech Support',
      'ipAddress': '192.168.2.178',
      'time': '2024-08-05 12:30:45',
      'entryTime': '2024-08-05 12:30:45',
      'checkoutTime': '2024-08-05 13:15:20',
      'duration': '44m',
      'status': 'Completed',
    },
    {
      'name': 'Sophie Martin',
      'country': 'France',
      'room': 'General Chat',
      'ipAddress': '203.0.113.88',
      'time': '2024-08-05 11:45:12',
      'entryTime': '2024-08-05 11:45:12',
      'checkoutTime': '2024-08-05 12:30:50',
      'duration': '45m',
      'status': 'Completed',
    },
    {
      'name': 'Hiroshi Tanaka',
      'country': 'Japan',
      'room': 'Gaming Zone',
      'ipAddress': '198.51.100.77',
      'time': '2024-08-05 17:20:30',
      'entryTime': '2024-08-05 17:20:30',
      'checkoutTime': null,
      'duration': 'Active',
      'status': 'Online',
    },
    {
      'name': 'Emma Wilson',
      'country': 'Australia',
      'room': 'Study Group',
      'ipAddress': '172.16.1.99',
      'time': '2024-08-05 10:15:25',
      'entryTime': '2024-08-05 10:15:25',
      'checkoutTime': '2024-08-05 11:30:15',
      'duration': '1h 14m',
      'status': 'Completed',
    },
  ];

  String searchQuery = '';
  String selectedRoomFilter = 'All Rooms';
  List<String> availableRooms = ['All Rooms'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    _animationController.forward();

    // Extract unique rooms for filter
    Set<String> rooms = logs.map((log) => log['room'] as String).toSet();
    availableRooms.addAll(rooms);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredLogs {
    return logs.where((log) {
      final matchesSearch =
          log['name'].toLowerCase().contains(searchQuery.toLowerCase()) ||
          log['country'].toLowerCase().contains(searchQuery.toLowerCase()) ||
          log['room'].toLowerCase().contains(searchQuery.toLowerCase()) ||
          log['ipAddress'].toLowerCase().contains(searchQuery.toLowerCase());

      final matchesRoom =
          selectedRoomFilter == 'All Rooms' ||
          log['room'] == selectedRoomFilter;

      return matchesSearch && matchesRoom;
    }).toList();
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Online':
        return Colors.green;
      case 'Completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData getStatusIcon(String status) {
    switch (status) {
      case 'Online':
        return Icons.circle;
      case 'Completed':
        return Icons.check_circle;
      default:
        return Icons.help_outline;
    }
  }

  void _showDeleteAllDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: widget.currentTheme['cardBg'],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.delete_sweep, color: Colors.red, size: 24),
                SizedBox(width: 12),
                Text(
                  'Delete All Logs',
                  style: TextStyle(
                    color: widget.currentTheme['textPrimary'],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Are you sure you want to delete all logs? This action cannot be undone.',
                  style: TextStyle(
                    color: widget.currentTheme['textPrimary'],
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'This will permanently delete ${logs.length} log entries.',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: widget.currentTheme['textSecondary']),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    logs.clear();
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('All logs deleted successfully!'),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Delete All',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  void _showDeleteRoomLogsDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: widget.currentTheme['cardBg'],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.delete_outline, color: Colors.orange, size: 24),
                SizedBox(width: 12),
                Text(
                  'Delete Room Logs',
                  style: TextStyle(
                    color: widget.currentTheme['textPrimary'],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select a room to delete all its logs:',
                  style: TextStyle(
                    color: widget.currentTheme['textPrimary'],
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: widget.currentTheme['mainBg'],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: widget.currentTheme['textSecondary'].withOpacity(
                        0.3,
                      ),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value:
                          selectedRoomFilter == 'All Rooms'
                              ? availableRooms.firstWhere(
                                (room) => room != 'All Rooms',
                              )
                              : selectedRoomFilter,
                      isExpanded: true,
                      dropdownColor: widget.currentTheme['cardBg'],
                      style: TextStyle(
                        color: widget.currentTheme['textPrimary'],
                      ),
                      items:
                          availableRooms
                              .where((room) => room != 'All Rooms')
                              .map((String room) {
                                final roomLogCount =
                                    logs
                                        .where((log) => log['room'] == room)
                                        .length;
                                return DropdownMenuItem<String>(
                                  value: room,
                                  child: Text('$room ($roomLogCount logs)'),
                                );
                              })
                              .toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedRoomFilter = newValue!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: widget.currentTheme['textSecondary']),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final roomToDelete =
                      selectedRoomFilter == 'All Rooms'
                          ? availableRooms.firstWhere(
                            (room) => room != 'All Rooms',
                          )
                          : selectedRoomFilter;

                  final logsToDeleteCount =
                      logs.where((log) => log['room'] == roomToDelete).length;

                  setState(() {
                    logs.removeWhere((log) => log['room'] == roomToDelete);
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Deleted $logsToDeleteCount logs from $roomToDelete',
                      ),
                      backgroundColor: Colors.orange,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Delete Room Logs',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildInfoCard(
    String title,
    String value,
    IconData icon, {
    Color? valueColor,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.currentTheme['cardBg'],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: widget.currentTheme['textSecondary']),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: widget.currentTheme['textSecondary'],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? widget.currentTheme['textPrimary'],
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.only(top: 16, right: 16, bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: widget.currentTheme['mainBg'],
        boxShadow: [
          BoxShadow(
            color: widget.currentTheme['shadow'],
            blurRadius: 30,
            offset: Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          EnhancedHeader(
            currentTheme: widget.currentTheme,
            title: 'System Logs',
            subtitle: 'User Activity Tracking',
            description: 'Monitor user sessions and activities',
          ),

          // Stats Cards
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: widget.currentTheme['cardBg'],
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: widget.currentTheme['shadow'],
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.list_alt, color: Colors.blue, size: 24),
                        SizedBox(height: 8),
                        Text(
                          logs.length.toString(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: widget.currentTheme['textPrimary'],
                          ),
                        ),
                        Text(
                          'Total Logs',
                          style: TextStyle(
                            fontSize: 12,
                            color: widget.currentTheme['textSecondary'],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: widget.currentTheme['cardBg'],
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: widget.currentTheme['shadow'],
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.circle, color: Colors.green, size: 24),
                        SizedBox(height: 8),
                        Text(
                          logs
                              .where((log) => log['status'] == 'Online')
                              .length
                              .toString(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: widget.currentTheme['textPrimary'],
                          ),
                        ),
                        Text(
                          'Online Users',
                          style: TextStyle(
                            fontSize: 12,
                            color: widget.currentTheme['textSecondary'],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: widget.currentTheme['cardBg'],
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: widget.currentTheme['shadow'],
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.meeting_room,
                          color: Colors.purple,
                          size: 24,
                        ),
                        SizedBox(height: 8),
                        Text(
                          (availableRooms.length - 1).toString(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: widget.currentTheme['textPrimary'],
                          ),
                        ),
                        Text(
                          'Active Rooms',
                          style: TextStyle(
                            fontSize: 12,
                            color: widget.currentTheme['textSecondary'],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Action Buttons
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _showDeleteAllDialog,
                    icon: Icon(
                      Icons.delete_sweep,
                      color: Colors.white,
                      size: 20,
                    ),
                    label: Text(
                      'Delete All Logs',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _showDeleteRoomLogsDialog,
                    icon: Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                      size: 20,
                    ),
                    label: Text(
                      'Delete Room Logs',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Search and Filter
          Container(
            margin: EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    style: TextStyle(color: widget.currentTheme['textPrimary']),
                    decoration: InputDecoration(
                      hintText: 'Search logs...',
                      hintStyle: TextStyle(
                        color: widget.currentTheme['textSecondary'],
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: widget.currentTheme['textSecondary'],
                      ),
                      filled: true,
                      fillColor: widget.currentTheme['cardBg'],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: widget.currentTheme['cardBg'],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedRoomFilter,
                        isExpanded: true,
                        dropdownColor: widget.currentTheme['cardBg'],
                        style: TextStyle(
                          color: widget.currentTheme['textPrimary'],
                        ),
                        items:
                            availableRooms.map((String room) {
                              return DropdownMenuItem<String>(
                                value: room,
                                child: Text(room),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedRoomFilter = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Logs List
          Expanded(child: _buildLogsList()),
        ],
      ),
    );
  }

  Widget _buildLogsList() {
    if (filteredLogs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.list_alt,
              size: 64,
              color: widget.currentTheme['accent'],
            ),
            SizedBox(height: 16),
            Text(
              'No Logs Found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: widget.currentTheme['textPrimary'],
              ),
            ),
            Text(
              'Try adjusting your search or filter',
              style: TextStyle(color: widget.currentTheme['textSecondary']),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20),
      itemCount: filteredLogs.length,
      itemBuilder: (context, index) {
        final log = filteredLogs[index];
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: widget.currentTheme['cardBg'],
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: widget.currentTheme['shadow'],
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ExpansionTile(
            tilePadding: EdgeInsets.all(16),
            childrenPadding: EdgeInsets.all(16),
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: getStatusColor(log['status']),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                getStatusIcon(log['status']),
                color: Colors.white,
                size: 28,
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log['name'],
                  style: TextStyle(
                    color: widget.currentTheme['textPrimary'],
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  log['country'],
                  style: TextStyle(
                    color: widget.currentTheme['accent'],
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Text(
                  'Room: ${log['room']}',
                  style: TextStyle(
                    color: widget.currentTheme['textSecondary'],
                    fontSize: 12,
                  ),
                ),
                Text(
                  'IP: ${log['ipAddress']}',
                  style: TextStyle(
                    color: widget.currentTheme['textSecondary'],
                    fontSize: 12,
                  ),
                ),
                Text(
                  'Duration: ${log['duration']}',
                  style: TextStyle(
                    color: widget.currentTheme['textSecondary'],
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: getStatusColor(log['status']),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        getStatusIcon(log['status']),
                        color: Colors.white,
                        size: 12,
                      ),
                      SizedBox(width: 4),
                      Text(
                        log['status'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            trailing: Icon(
              Icons.expand_more,
              color: widget.currentTheme['textSecondary'],
            ),
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: widget.currentTheme['mainBg'],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Information
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            'Country',
                            log['country'],
                            Icons.flag,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _buildInfoCard(
                            'Room',
                            log['room'],
                            Icons.meeting_room,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            'IP Address',
                            log['ipAddress'],
                            Icons.computer,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _buildInfoCard(
                            'Status',
                            log['status'],
                            Icons.info,
                            valueColor: getStatusColor(log['status']),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            'Entry Time',
                            log['entryTime'],
                            Icons.login,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _buildInfoCard(
                            'Checkout Time',
                            log['checkoutTime'] ?? 'Still Online',
                            Icons.logout,
                            valueColor:
                                log['checkoutTime'] == null
                                    ? Colors.green
                                    : null,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            'Session Duration',
                            log['duration'],
                            Icons.timer,
                            valueColor:
                                log['duration'] == 'Active'
                                    ? Colors.green
                                    : null,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _buildInfoCard(
                            'Log Time',
                            log['time'],
                            Icons.schedule,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
