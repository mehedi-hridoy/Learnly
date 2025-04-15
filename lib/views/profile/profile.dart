import 'package:flutter/material.dart';
import 'edit_profile.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);


  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}


class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> userData = {
    'name': 'User Name',
    'username': '@username',
    'email': 'user@example.com',
    'phone': '+880 1234567890',
    'profileImage': null,
    'tasksCompleted': 0,
  };


  @override
  Widget build(BuildContext context) {
    
    final Color backgroundColor = const Color(0xFFF9FAFE);
    final Color cardBackground = const Color(0xFFFFFFFF);
    final Color primaryColor = const Color(0xFF6C63FF);
    final Color secondaryColor = const Color(0xFF8A87FF);
    final Color accentColor = const Color(0xFFAFA8FF);
    final Color tertiaryColor = const Color(0xFFFF7D7D);
    final Color textPrimary = const Color(0xFF2B2D42);
    final Color textSecondary = const Color(0xFF8D99AE);
    final Color dividerColor = const Color(0xFFEDF2F7);


    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: cardBackground.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.settings_outlined, color: textPrimary, size: 20),
              ),
              onPressed: () {
                
              },
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          
          SliverToBoxAdapter(
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                
                Container(
                  height: 240,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [primaryColor, secondaryColor],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),
                
                Positioned(
                  top: 110,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      
                      Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: SweepGradient(
                            colors: [primaryColor, accentColor, secondaryColor, primaryColor],
                            stops: const [0.0, 0.3, 0.6, 1.0],
                          ),
                        ),
                      ),
                      
                      CircleAvatar(
                        radius: 56,
                        backgroundColor: cardBackground,
                        backgroundImage: userData['profileImage'] != null
                            ? FileImage(userData['profileImage'])
                            : null,
                        child: userData['profileImage'] == null
                            ? Icon(Icons.person, size: 50, color: textSecondary)
                            : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),


          
          SliverList(
            delegate: SliverChildListDelegate([
              
              const SizedBox(height: 50),


             
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                   
                    Text(
                      userData['name'],
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userData['username'],
                      style: TextStyle(
                        fontSize: 16,
                        color: textSecondary,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 12),


                    Container(
                      margin: const EdgeInsets.only(top: 16, bottom: 24),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: cardBackground,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatItem(
                            icon: Icons.task_alt,
                            value: userData['tasksCompleted'].toString(),
                            label: 'Tasks',
                            iconColor: primaryColor,
                          ),
                          _buildDivider(),
                          _buildStatItem(
                            icon: Icons.star,
                            value: '4.9',
                            label: 'Rating',
                            iconColor: Colors.amber,
                          ),
                          _buildDivider(),
                          _buildStatItem(
                            icon: Icons.emoji_events,
                            value: '3',
                            label: 'Badges',
                            iconColor: Colors.orange,
                          ),
                        ],
                      ),
                    ),


                    
                    Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardBackground,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildContactItem(
                            icon: Icons.email_outlined,
                            label: 'Email',
                            value: userData['email'],
                            iconColor: primaryColor,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Divider(),
                          ),
                          _buildContactItem(
                            icon: Icons.phone_outlined,
                            label: 'Phone',
                            value: userData['phone'],
                            iconColor: primaryColor,
                          ),
                        ],
                      ),
                    ),


                    ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfilePage(userData: userData),
                          ),
                        );
                        if (result != null && result is Map<String, dynamic>) {
                          setState(() {
                            userData = result;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        minimumSize: const Size(double.infinity, 0),
                      ),
                      child: const Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),


                    const SizedBox(height: 24),
                   
                   
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: cardBackground,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildMenuTile(
                            icon: Icons.language_outlined,
                            title: 'Language',
                            iconColor: primaryColor,
                            onTap: () {
                              _showLanguageDialog(context, cardBackground, textPrimary, textSecondary, primaryColor);
                            },
                          ),
                          Divider(height: 1, thickness: 1, color: dividerColor),
                          _buildMenuTile(
                            icon: Icons.location_on_outlined,
                            title: 'Location',
                            iconColor: secondaryColor,
                            onTap: () {
                              _showLocationDialog(context, cardBackground, textPrimary, textSecondary, primaryColor);
                            },
                          ),
                          Divider(height: 1, thickness: 1, color: dividerColor),
                          _buildMenuTile(
                            icon: Icons.subscriptions_outlined,
                            title: 'Subscription',
                            iconColor: accentColor,
                            onTap: () {
                              _showSubscriptionDialog(context, cardBackground, textPrimary, textSecondary, primaryColor);
                            },
                          ),
                        ],
                      ),
                    ),
                   
                    
                    Container(
                      margin: const EdgeInsets.only(bottom: 32),
                      decoration: BoxDecoration(
                        color: cardBackground,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildMenuTile(
                            icon: Icons.restart_alt_outlined,
                            title: 'Restart Progress',
                            iconColor: Colors.orange,
                            onTap: () {
                              _showRestartDialog(context, cardBackground, textPrimary, textSecondary, tertiaryColor);
                            },
                          ),
                          Divider(height: 1, thickness: 1, color: dividerColor),
                          _buildMenuTile(
                            icon: Icons.logout_outlined,
                            title: 'Log Out',
                            iconColor: tertiaryColor,
                            textColor: tertiaryColor,
                            onTap: () {
                              _showLogoutDialog(context, cardBackground, textPrimary, textSecondary, tertiaryColor);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }


  
  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color iconColor,
  }) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 24),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2B2D42),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: const Color(0xFF8D99AE),
          ),
        ),
      ],
    );
  }


  Widget _buildDivider() {
    return Container(
      height: 30,
      width: 1,
      color: const Color(0xFFEDF2F7),
    );
  }


  Widget _buildContactItem({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: const Color(0xFF8D99AE),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF2B2D42),
              ),
            ),
          ],
        ),
      ],
    );
  }


  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required Color iconColor,
    Color? textColor,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? const Color(0xFF2B2D42),
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF8D99AE),
              size: 14,
            ),
          ],
        ),
      ),
    );
  }


  
  void _showLanguageDialog(BuildContext context, Color cardBackground, Color textPrimary, Color textSecondary, Color primaryColor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: cardBackground,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Language',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: textSecondary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Coming Soon!',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Language preferences will be available in future updates.',
              style: TextStyle(
                fontSize: 14,
                color: textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, 0),
              ),
              child: const Text('OK'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }


  void _showLocationDialog(BuildContext context, Color cardBackground, Color textPrimary, Color textSecondary, Color primaryColor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: cardBackground,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Location',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: textSecondary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildLocationOption(context, 'Dhaka', primaryColor),
            _buildLocationOption(context, 'Chittagong', primaryColor),
            _buildLocationOption(context, 'Rajshahi', primaryColor),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }


  Widget _buildLocationOption(BuildContext context, String location, Color primaryColor) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location set to $location'),
            backgroundColor: primaryColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.all(16),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Icon(Icons.location_on, color: primaryColor, size: 20),
            const SizedBox(width: 16),
            Text(
              location,
              style: TextStyle(
                fontSize: 16,
                color: const Color(0xFF2B2D42),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _showSubscriptionDialog(BuildContext context, Color cardBackground, Color textPrimary, Color textSecondary, Color primaryColor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: cardBackground,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subscription Plans',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: textSecondary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: primaryColor.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Coming Soon!',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Premium subscription features will be available soon. Stay tuned for updates!',
                    style: TextStyle(
                      fontSize: 14,
                      color: textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, 0),
              ),
              child: const Text('OK'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }


  void _showRestartDialog(BuildContext context, Color cardBackground, Color textPrimary, Color textSecondary, Color dangerColor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Restart Progress',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to restart your progress? This action cannot be undone.',
          style: TextStyle(
            fontSize: 14,
            color: textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Progress has been restarted'),
                  backgroundColor: dangerColor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.all(16),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: dangerColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Restart'),
          ),
        ],
      ),
    );
  }


  void _showLogoutDialog(BuildContext context, Color cardBackground, Color textPrimary, Color textSecondary, Color dangerColor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Log Out',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to log out?',
          style: TextStyle(
            fontSize: 14,
            color: textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: dangerColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Log Out'),
          ),
        ],
      ),
    );
  }
}

