// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, deprecated_member_use, avoid_web_libraries_in_flutter

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;
import '../widgets/enhanced_header.dart';

class VIPPage extends StatefulWidget {
  final Map<String, dynamic> currentTheme;

  const VIPPage({super.key, required this.currentTheme});

  @override
  _VIPPageState createState() => _VIPPageState();
}

class _VIPPageState extends State<VIPPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  final ImagePicker _picker = ImagePicker();

  List<Map<String, dynamic>> vipUsers = [
    {
      'name': 'John Smith',
      'username': 'johnsmith123',
      'email': 'john.smith@example.com',
      'tier': 'VIP',
      'joinDate': '2024-01-15',
      'profileAddDate': '2024-01-10',
      'endDate': '2025-01-15',
      'status': 'Active',
      'avatar': Icons.person,
      'imagePath': null,
      'imageBytes': null,
      'backgroundImagePath': null,
      'backgroundImageBytes': null,
      'address': '123 Main St, New York, NY',
      'birthDate': '1990-06-15',
      'maritalStatus': 'Single',
      'work': 'Software Engineer',
      'banned': false,
      'likes': 142,
      'visited': 523,
      'presenceRate': 89.5,
      'aboutMe': 'Passionate developer who loves coding and technology.',
      'statusText': 'Currently working on exciting projects!',
      'profilePassword': 'profile123',
    },
    {
      'name': 'Sarah Johnson',
      'username': 'sarahj',
      'email': 'sarah.j@example.com',
      'tier': 'Royal',
      'joinDate': '2023-12-08',
      'profileAddDate': '2023-12-01',
      'endDate': '2024-12-08',
      'status': 'Active',
      'avatar': Icons.person,
      'imagePath': null,
      'imageBytes': null,
      'backgroundImagePath': null,
      'backgroundImageBytes': null,
      'address': '456 Oak Ave, Los Angeles, CA',
      'birthDate': '1985-03-22',
      'maritalStatus': 'Married',
      'work': 'Marketing Director',
      'banned': false,
      'likes': 298,
      'visited': 847,
      'presenceRate': 95.2,
      'aboutMe': 'Creative marketing professional with 10+ years experience.',
      'statusText': 'Living my best life! 🌟',
      'profilePassword': 'royal456',
    },
    {
      'name': 'Michael Brown',
      'username': 'mikebrown',
      'email': 'mike.brown@example.com',
      'tier': 'Protected',
      'joinDate': '2023-11-22',
      'profileAddDate': '2023-11-15',
      'endDate': '2024-11-22',
      'status': 'Inactive',
      'avatar': Icons.person,
      'imagePath': null,
      'imageBytes': null,
      'backgroundImagePath': null,
      'backgroundImageBytes': null,
      'address': '789 Pine St, Chicago, IL',
      'birthDate': '1992-09-10',
      'maritalStatus': 'Single',
      'work': 'Graphic Designer',
      'banned': false,
      'likes': 76,
      'visited': 234,
      'presenceRate': 67.8,
      'aboutMe': 'Designer with a passion for visual storytelling.',
      'statusText': 'Taking a break from social media.',
      'profilePassword': 'protected789',
    },
  ];

  String selectedTier = 'All';
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredVIPs {
    return vipUsers.where((vip) {
      final matchesSearch =
          vip['name'].toLowerCase().contains(searchQuery.toLowerCase()) ||
          vip['email'].toLowerCase().contains(searchQuery.toLowerCase()) ||
          vip['username'].toLowerCase().contains(searchQuery.toLowerCase());
      final matchesTier = selectedTier == 'All' || vip['tier'] == selectedTier;
      return matchesSearch && matchesTier;
    }).toList();
  }

  Color getTierColor(String tier) {
    switch (tier) {
      case 'Royal':
        return Color(0xFFFFD700); // Gold/Yellow
      case 'VIP':
        return Color(0xFFFF8C00); // Orange
      case 'Protected':
        return Color(0xFF8A2BE2); // Violet
      default:
        return Colors.blue;
    }
  }

  IconData getTierIcon(String tier) {
    switch (tier) {
      case 'Royal':
        return Icons.diamond;
      case 'VIP':
        return Icons.star;
      case 'Protected':
        return Icons.shield;
      default:
        return Icons.person;
    }
  }

  Future<void> _pickImage(Function(String?, Uint8List?) onImageSelected) async {
    try {
      if (kIsWeb) {
        // Web-specific implementation
        final html.FileUploadInputElement uploadInput =
            html.FileUploadInputElement();
        uploadInput.accept = 'image/*';
        uploadInput.click();

        uploadInput.onChange.listen((e) {
          final files = uploadInput.files;
          if (files!.length == 1) {
            final file = files[0];
            final reader = html.FileReader();

            reader.readAsArrayBuffer(file);
            reader.onLoadEnd.listen((e) {
              final bytes = reader.result as Uint8List;
              onImageSelected(null, bytes);
            });
          }
        });
      } else {
        // Mobile implementation
        final XFile? image = await _picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 300,
          maxHeight: 300,
          imageQuality: 80,
        );
        if (image != null) {
          onImageSelected(image.path, null);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  Widget? _buildImageWidget({
    String? imagePath,
    Uint8List? imageBytes,
    required double size,
    bool isCircular = true,
  }) {
    if (kIsWeb && imageBytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(isCircular ? size / 2 : 12),
        child: Image.memory(
          imageBytes,
          fit: BoxFit.cover,
          width: size,
          height: size,
        ),
      );
    } else if (!kIsWeb && imagePath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(isCircular ? size / 2 : 12),
        child: Image.file(
          File(imagePath),
          fit: BoxFit.cover,
          width: size,
          height: size,
        ),
      );
    }
    return null;
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: widget.currentTheme['textPrimary'],
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: widget.currentTheme['mainBg'],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.currentTheme['textSecondary'].withOpacity(0.3),
            ),
          ),
          child: TextField(
            controller: controller,
            style: TextStyle(color: widget.currentTheme['textPrimary']),
            keyboardType: keyboardType,
            obscureText: obscureText,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: 'Enter $label',
              hintStyle: TextStyle(color: widget.currentTheme['textSecondary']),
              prefixIcon: Icon(
                icon,
                color: widget.currentTheme['textSecondary'],
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showAddVIPDialog() {
    // Controllers for all form fields
    final nameController = TextEditingController();
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final profilePasswordController = TextEditingController();
    final addressController = TextEditingController();
    final birthDateController = TextEditingController();
    final maritalStatusController = TextEditingController();
    final workController = TextEditingController();
    final likesController = TextEditingController();
    final visitedController = TextEditingController();
    final presenceRateController = TextEditingController();
    final profileAddDateController = TextEditingController();
    final endDateController = TextEditingController();
    final aboutMeController = TextEditingController();
    final statusTextController = TextEditingController();

    String selectedNewTier = 'VIP';
    bool isBanned = false;
    String? selectedImagePath;
    Uint8List? selectedImageBytes;
    String? selectedBackgroundImagePath;
    Uint8List? selectedBackgroundImageBytes;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setDialogState) => Dialog(
                  backgroundColor: Colors.transparent,
                  child: Container(
                    width: 600,
                    height: MediaQuery.of(context).size.height * 0.9,
                    decoration: BoxDecoration(
                      color: widget.currentTheme['cardBg'],
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: widget.currentTheme['shadow'],
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Header
                        Container(
                          padding: EdgeInsets.all(24),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: widget.currentTheme['accent'],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.person_add,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Add New VIP Member',
                                      style: TextStyle(
                                        color:
                                            widget.currentTheme['textPrimary'],
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Create a comprehensive VIP profile',
                                      style: TextStyle(
                                        color:
                                            widget
                                                .currentTheme['textSecondary'],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: Icon(
                                  Icons.close,
                                  color: widget.currentTheme['textSecondary'],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Scrollable Form Content
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Profile Images Section
                                Container(
                                  width: double.infinity,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: widget.currentTheme['mainBg'],
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: widget.currentTheme['accent']
                                          .withOpacity(0.3),
                                      width: 2,
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      // Background Image
                                      GestureDetector(
                                        onTap:
                                            () => _pickImage((
                                              imagePath,
                                              imageBytes,
                                            ) {
                                              setDialogState(() {
                                                selectedBackgroundImagePath =
                                                    imagePath;
                                                selectedBackgroundImageBytes =
                                                    imageBytes;
                                              });
                                            }),
                                        child: Container(
                                          width: double.infinity,
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                            gradient: LinearGradient(
                                              colors: [
                                                widget.currentTheme['accent']
                                                    .withOpacity(0.3),
                                                widget.currentTheme['accent']
                                                    .withOpacity(0.1),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                          ),
                                          child:
                                              _buildImageWidget(
                                                imagePath:
                                                    selectedBackgroundImagePath,
                                                imageBytes:
                                                    selectedBackgroundImageBytes,
                                                size: double.infinity,
                                                isCircular: false,
                                              ) ??
                                              Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.add_photo_alternate,
                                                      color:
                                                          widget
                                                              .currentTheme['accent'],
                                                      size: 32,
                                                    ),
                                                    SizedBox(height: 8),
                                                    Text(
                                                      'Add Background Image',
                                                      style: TextStyle(
                                                        color:
                                                            widget
                                                                .currentTheme['textSecondary'],
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                        ),
                                      ),

                                      // Profile Picture
                                      Positioned(
                                        bottom: 16,
                                        left: 24,
                                        child: GestureDetector(
                                          onTap:
                                              () => _pickImage((
                                                imagePath,
                                                imageBytes,
                                              ) {
                                                setDialogState(() {
                                                  selectedImagePath = imagePath;
                                                  selectedImageBytes =
                                                      imageBytes;
                                                });
                                              }),
                                          child: Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              color:
                                                  widget.currentTheme['cardBg'],
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              border: Border.all(
                                                color:
                                                    widget
                                                        .currentTheme['accent'],
                                                width: 3,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  blurRadius: 10,
                                                  offset: Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child:
                                                _buildImageWidget(
                                                  imagePath: selectedImagePath,
                                                  imageBytes:
                                                      selectedImageBytes,
                                                  size: 100,
                                                ) ??
                                                Icon(
                                                  Icons.add_a_photo,
                                                  color:
                                                      widget
                                                          .currentTheme['accent'],
                                                  size: 32,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 24),

                                // Basic Information
                                Text(
                                  'Basic Information',
                                  style: TextStyle(
                                    color: widget.currentTheme['textPrimary'],
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 16),

                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildFormField(
                                        label: 'Full Name',
                                        controller: nameController,
                                        icon: Icons.person,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: _buildFormField(
                                        label: 'Username',
                                        controller: usernameController,
                                        icon: Icons.alternate_email,
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 16),

                                _buildFormField(
                                  label: 'Email Address',
                                  controller: emailController,
                                  icon: Icons.email,
                                  keyboardType: TextInputType.emailAddress,
                                ),

                                SizedBox(height: 16),

                                _buildFormField(
                                  label: 'Password',
                                  controller: passwordController,
                                  icon: Icons.lock,
                                  obscureText: true,
                                ),

                                SizedBox(height: 16),

                                _buildFormField(
                                  label: 'Profile Password',
                                  controller: profilePasswordController,
                                  icon: Icons.security,
                                  obscureText: true,
                                ),

                                SizedBox(height: 16),

                                _buildFormField(
                                  label: 'Address',
                                  controller: addressController,
                                  icon: Icons.location_on,
                                ),

                                SizedBox(height: 20),

                                // Personal Details
                                Text(
                                  'Personal Details',
                                  style: TextStyle(
                                    color: widget.currentTheme['textPrimary'],
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 16),

                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildFormField(
                                        label: 'Birth Date',
                                        controller: birthDateController,
                                        icon: Icons.cake,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: _buildFormField(
                                        label: 'Marital Status',
                                        controller: maritalStatusController,
                                        icon: Icons.favorite,
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 16),

                                _buildFormField(
                                  label: 'Work/Profession',
                                  controller: workController,
                                  icon: Icons.work,
                                ),

                                SizedBox(height: 20),

                                // VIP Settings
                                Text(
                                  'VIP Settings',
                                  style: TextStyle(
                                    color: widget.currentTheme['textPrimary'],
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 16),

                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Profile Type',
                                            style: TextStyle(
                                              color:
                                                  widget
                                                      .currentTheme['textPrimary'],
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  widget.currentTheme['mainBg'],
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: widget
                                                    .currentTheme['textSecondary']
                                                    .withOpacity(0.3),
                                              ),
                                            ),
                                            child: DropdownButtonFormField<
                                              String
                                            >(
                                              value: selectedNewTier,
                                              dropdownColor:
                                                  widget.currentTheme['cardBg'],
                                              style: TextStyle(
                                                color:
                                                    widget
                                                        .currentTheme['textPrimary'],
                                              ),
                                              decoration: InputDecoration(
                                                prefixIcon: Icon(
                                                  Icons.workspace_premium,
                                                  color:
                                                      widget
                                                          .currentTheme['textSecondary'],
                                                ),
                                                border: InputBorder.none,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 16,
                                                    ),
                                              ),
                                              items:
                                                  [
                                                    'Protected',
                                                    'VIP',
                                                    'Royal',
                                                  ].map((tier) {
                                                    return DropdownMenuItem(
                                                      value: tier,
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            width: 20,
                                                            height: 20,
                                                            decoration: BoxDecoration(
                                                              color:
                                                                  getTierColor(
                                                                    tier,
                                                                  ),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    4,
                                                                  ),
                                                            ),
                                                            child: Icon(
                                                              getTierIcon(tier),
                                                              color:
                                                                  Colors.white,
                                                              size: 12,
                                                            ),
                                                          ),
                                                          SizedBox(width: 12),
                                                          Text(tier),
                                                        ],
                                                      ),
                                                    );
                                                  }).toList(),
                                              onChanged: (value) {
                                                setDialogState(() {
                                                  selectedNewTier = value!;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: _buildFormField(
                                        label: 'Profile Add Date',
                                        controller: profileAddDateController,
                                        icon: Icons.date_range,
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 16),

                                _buildFormField(
                                  label: 'Profile End Date',
                                  controller: endDateController,
                                  icon: Icons.event,
                                ),

                                SizedBox(height: 16),

                                // Ban Status
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: widget.currentTheme['mainBg'],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: widget
                                          .currentTheme['textSecondary']
                                          .withOpacity(0.3),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.block,
                                        color:
                                            widget
                                                .currentTheme['textSecondary'],
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        'Banned Status',
                                        style: TextStyle(
                                          color:
                                              widget
                                                  .currentTheme['textPrimary'],
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Spacer(),
                                      Switch(
                                        value: isBanned,
                                        onChanged: (value) {
                                          setDialogState(() {
                                            isBanned = value;
                                          });
                                        },
                                        activeColor: Colors.red,
                                        inactiveThumbColor: Colors.green,
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 20),

                                // Statistics
                                Text(
                                  'Statistics',
                                  style: TextStyle(
                                    color: widget.currentTheme['textPrimary'],
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 16),

                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildFormField(
                                        label: 'Likes',
                                        controller: likesController,
                                        icon: Icons.thumb_up,
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: _buildFormField(
                                        label: 'Visited',
                                        controller: visitedController,
                                        icon: Icons.visibility,
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 16),

                                _buildFormField(
                                  label: 'Presence Rate (%)',
                                  controller: presenceRateController,
                                  icon: Icons.show_chart,
                                  keyboardType: TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                ),

                                SizedBox(height: 20),

                                // About & Status
                                Text(
                                  'About & Status',
                                  style: TextStyle(
                                    color: widget.currentTheme['textPrimary'],
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 16),

                                _buildFormField(
                                  label: 'About Me',
                                  controller: aboutMeController,
                                  icon: Icons.info,
                                  maxLines: 3,
                                ),

                                SizedBox(height: 16),

                                _buildFormField(
                                  label: 'Status Message',
                                  controller: statusTextController,
                                  icon: Icons.message,
                                  maxLines: 2,
                                ),

                                SizedBox(height: 32),
                              ],
                            ),
                          ),
                        ),

                        // Action Buttons
                        Container(
                          padding: EdgeInsets.all(24),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                        color: widget
                                            .currentTheme['textSecondary']
                                            .withOpacity(0.3),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color:
                                          widget.currentTheme['textSecondary'],
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (nameController.text.isNotEmpty &&
                                        usernameController.text.isNotEmpty &&
                                        emailController.text.isNotEmpty) {
                                      setState(() {
                                        vipUsers.add({
                                          'name': nameController.text,
                                          'username': usernameController.text,
                                          'email': emailController.text,
                                          'tier': selectedNewTier,
                                          'joinDate': DateTime.now()
                                              .toString()
                                              .substring(0, 10),
                                          'profileAddDate':
                                              profileAddDateController
                                                      .text
                                                      .isNotEmpty
                                                  ? profileAddDateController
                                                      .text
                                                  : DateTime.now()
                                                      .subtract(
                                                        Duration(days: 5),
                                                      )
                                                      .toString()
                                                      .substring(0, 10),
                                          'endDate':
                                              endDateController.text.isNotEmpty
                                                  ? endDateController.text
                                                  : DateTime.now()
                                                      .add(Duration(days: 365))
                                                      .toString()
                                                      .substring(0, 10),
                                          'status':
                                              isBanned ? 'Banned' : 'Active',
                                          'avatar': Icons.person,
                                          'imagePath': selectedImagePath,
                                          'imageBytes': selectedImageBytes,
                                          'backgroundImagePath':
                                              selectedBackgroundImagePath,
                                          'backgroundImageBytes':
                                              selectedBackgroundImageBytes,
                                          'address': addressController.text,
                                          'birthDate': birthDateController.text,
                                          'maritalStatus':
                                              maritalStatusController.text,
                                          'work': workController.text,
                                          'banned': isBanned,
                                          'likes':
                                              int.tryParse(
                                                likesController.text,
                                              ) ??
                                              0,
                                          'visited':
                                              int.tryParse(
                                                visitedController.text,
                                              ) ??
                                              0,
                                          'presenceRate':
                                              double.tryParse(
                                                presenceRateController.text,
                                              ) ??
                                              0.0,
                                          'aboutMe': aboutMeController.text,
                                          'statusText':
                                              statusTextController.text,
                                          'profilePassword':
                                              profilePasswordController.text,
                                        });
                                      });
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'VIP member added successfully!',
                                          ),
                                          backgroundColor: Colors.green,
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        widget.currentTheme['accent'],
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    'Add VIP Member',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
            title: 'VIP Management',
            subtitle: 'Premium Members',
            description: 'Manage VIP users and their privileges',
          ),

          // Stats Cards - VIP Tiers
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
                        Icon(Icons.diamond, color: Color(0xFFFFD700), size: 24),
                        SizedBox(height: 8),
                        Text(
                          vipUsers
                              .where((vip) => vip['tier'] == 'Royal')
                              .length
                              .toString(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: widget.currentTheme['textPrimary'],
                          ),
                        ),
                        Text(
                          'Royal',
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
                        Icon(Icons.star, color: Color(0xFFFF8C00), size: 24),
                        SizedBox(height: 8),
                        Text(
                          vipUsers
                              .where((vip) => vip['tier'] == 'VIP')
                              .length
                              .toString(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: widget.currentTheme['textPrimary'],
                          ),
                        ),
                        Text(
                          'VIP',
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
                        Icon(Icons.shield, color: Color(0xFF8A2BE2), size: 24),
                        SizedBox(height: 8),
                        Text(
                          vipUsers
                              .where((vip) => vip['tier'] == 'Protected')
                              .length
                              .toString(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: widget.currentTheme['textPrimary'],
                          ),
                        ),
                        Text(
                          'Protected',
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

          // Search and Filter Bar
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
                      hintText: 'Search VIPs...',
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
                  child: DropdownButtonFormField<String>(
                    value: selectedTier,
                    dropdownColor: widget.currentTheme['cardBg'],
                    style: TextStyle(color: widget.currentTheme['textPrimary']),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: widget.currentTheme['cardBg'],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items:
                        ['All', 'Protected', 'VIP', 'Royal'].map((tier) {
                          return DropdownMenuItem(
                            value: tier,
                            child: Text(tier),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedTier = value!;
                      });
                    },
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _showAddVIPDialog,
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text('Add VIP', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.currentTheme['accent'],
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // VIP List
          Expanded(
            child:
                filteredVIPs.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_search,
                            size: 64,
                            color: widget.currentTheme['accent'],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No VIPs Found',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: widget.currentTheme['textPrimary'],
                            ),
                          ),
                          Text(
                            'Try adjusting your search or filters',
                            style: TextStyle(
                              color: widget.currentTheme['textSecondary'],
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      itemCount: filteredVIPs.length,
                      itemBuilder: (context, index) {
                        final vip = filteredVIPs[index];
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
                                color: getTierColor(vip['tier']),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: getTierColor(vip['tier']),
                                  width: 2,
                                ),
                              ),
                              child:
                                  _buildImageWidget(
                                    imagePath: vip['imagePath'],
                                    imageBytes: vip['imageBytes'],
                                    size: 60,
                                  ) ??
                                  Icon(
                                    getTierIcon(vip['tier']),
                                    color: Colors.white,
                                    size: 28,
                                  ),
                            ),
                            title: Text(
                              vip['name'],
                              style: TextStyle(
                                color: getTierColor(vip['tier']),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '@${vip['username'] ?? 'N/A'}',
                                  style: TextStyle(
                                    color: widget.currentTheme['textSecondary'],
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  vip['email'],
                                  style: TextStyle(
                                    color: widget.currentTheme['textSecondary'],
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: getTierColor(vip['tier']),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            getTierIcon(vip['tier']),
                                            color: Colors.white,
                                            size: 12,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            vip['tier'],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            vip['status'] == 'Active'
                                                ? Colors.green
                                                : vip['status'] == 'Banned'
                                                ? Colors.red
                                                : Colors.orange,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        vip['status'],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: PopupMenuButton(
                              color: widget.currentTheme['cardBg'],
                              icon: Icon(
                                Icons.more_vert,
                                color: widget.currentTheme['textSecondary'],
                              ),
                              itemBuilder:
                                  (context) => [
                                    PopupMenuItem(
                                      value: 'edit',
                                      child: Text(
                                        'Edit',
                                        style: TextStyle(
                                          color:
                                              widget
                                                  .currentTheme['textPrimary'],
                                        ),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'toggle_status',
                                      child: Text(
                                        vip['status'] == 'Active'
                                            ? 'Deactivate'
                                            : 'Activate',
                                        style: TextStyle(
                                          color:
                                              widget
                                                  .currentTheme['textPrimary'],
                                        ),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'ban',
                                      child: Text(
                                        vip['banned'] ? 'Unban' : 'Ban',
                                        style: TextStyle(color: Colors.orange),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'remove',
                                      child: Text(
                                        'Remove',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                              onSelected: (value) {
                                switch (value) {
                                  case 'edit':
                                    // Handle edit action
                                    break;
                                  case 'toggle_status':
                                    setState(() {
                                      vipUsers[vipUsers.indexOf(
                                            vip,
                                          )]['status'] =
                                          vip['status'] == 'Active'
                                              ? 'Inactive'
                                              : 'Active';
                                    });
                                    break;
                                  case 'ban':
                                    setState(() {
                                      bool newBanStatus = !vip['banned'];
                                      vipUsers[vipUsers.indexOf(
                                            vip,
                                          )]['banned'] =
                                          newBanStatus;
                                      vipUsers[vipUsers.indexOf(
                                            vip,
                                          )]['status'] =
                                          newBanStatus ? 'Banned' : 'Active';
                                    });
                                    break;
                                  case 'remove':
                                    setState(() {
                                      vipUsers.remove(vip);
                                    });
                                    break;
                                }
                              },
                            ),
                            children: [
                              // Detailed Information Panel
                              Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: widget.currentTheme['mainBg'],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Profile Background and Picture
                                    if (vip['backgroundImagePath'] != null ||
                                        vip['backgroundImageBytes'] != null)
                                      Container(
                                        width: double.infinity,
                                        height: 120,
                                        margin: EdgeInsets.only(bottom: 16),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: _buildImageWidget(
                                          imagePath: vip['backgroundImagePath'],
                                          imageBytes:
                                              vip['backgroundImageBytes'],
                                          size: double.infinity,
                                          isCircular: false,
                                        ),
                                      ),

                                    // Basic Info
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildInfoCard(
                                            'Address',
                                            vip['address'] ?? 'N/A',
                                            Icons.location_on,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: _buildInfoCard(
                                            'Birth Date',
                                            vip['birthDate'] ?? 'N/A',
                                            Icons.cake,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildInfoCard(
                                            'Marital Status',
                                            vip['maritalStatus'] ?? 'N/A',
                                            Icons.favorite,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: _buildInfoCard(
                                            'Work',
                                            vip['work'] ?? 'N/A',
                                            Icons.work,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16),

                                    // Statistics
                                    Text(
                                      'Statistics',
                                      style: TextStyle(
                                        color:
                                            widget.currentTheme['textPrimary'],
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildStatCard(
                                            'Likes',
                                            vip['likes']?.toString() ?? '0',
                                            Icons.thumb_up,
                                            Colors.blue,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: _buildStatCard(
                                            'Visited',
                                            vip['visited']?.toString() ?? '0',
                                            Icons.visibility,
                                            Colors.green,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: _buildStatCard(
                                            'Presence',
                                            '${vip['presenceRate']?.toString() ?? '0'}%',
                                            Icons.show_chart,
                                            Colors.orange,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16),

                                    // Dates
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildInfoCard(
                                            'Profile Add Date',
                                            vip['profileAddDate'] ?? 'N/A',
                                            Icons.date_range,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: _buildInfoCard(
                                            'Join Date',
                                            vip['joinDate'] ?? 'N/A',
                                            Icons.event,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildInfoCard(
                                            'End Date',
                                            vip['endDate'] ?? 'N/A',
                                            Icons.event_busy,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: _buildInfoCard(
                                            'Profile Password',
                                            vip['profilePassword'] != null &&
                                                    vip['profilePassword']
                                                        .isNotEmpty
                                                ? '••••••••'
                                                : 'N/A',
                                            Icons.security,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16),

                                    // About Me
                                    if (vip['aboutMe'] != null &&
                                        vip['aboutMe'].isNotEmpty) ...[
                                      Text(
                                        'About Me',
                                        style: TextStyle(
                                          color:
                                              widget
                                                  .currentTheme['textPrimary'],
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: widget.currentTheme['cardBg'],
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          vip['aboutMe'],
                                          style: TextStyle(
                                            color:
                                                widget
                                                    .currentTheme['textSecondary'],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 12),
                                    ],

                                    // Status Text
                                    if (vip['statusText'] != null &&
                                        vip['statusText'].isNotEmpty) ...[
                                      Text(
                                        'Status',
                                        style: TextStyle(
                                          color:
                                              widget
                                                  .currentTheme['textPrimary'],
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: getTierColor(
                                            vip['tier'],
                                          ).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: getTierColor(
                                              vip['tier'],
                                            ).withOpacity(0.3),
                                          ),
                                        ),
                                        child: Text(
                                          vip['statusText'],
                                          style: TextStyle(
                                            color: getTierColor(vip['tier']),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
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
              color: widget.currentTheme['textPrimary'],
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
