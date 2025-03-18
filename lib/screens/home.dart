import 'package:flutter/material.dart';
import 'package:infratrack/components/bottom_navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // A gradient background for a softer, more polished look.
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Custom AppBar
                Container(
                  color: const Color.fromARGB(0, 255, 255, 255),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.menu_rounded,
                            color: Color(0xFF2C3E50)),
                        onPressed: () {},
                      ),
                      const Text(
                        "HOME",
                        style: TextStyle(
                          color: Color(0xFF2C3E50),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.account_circle_rounded,
                            color: Color(0xFF2C3E50)),
                        onPressed: () {
                          Navigator.pushNamed(context, "/issue_description");
                        },
                      ),
                    ],
                  ),
                ),

                // Main Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Column(
                      children: [
                        // Logo and Headings
                        const SizedBox(height: 50),
                        Image.asset(
                          'assets/infra_track_logo.png',
                          height: 200,
                        ),

                        // Ensure Issue Cards are right below the logo
                        const SizedBox(
                            height:
                                20), // Adjust this space to fine-tune the layout
                        IssueCard(
                          title: "High Priority Issues",
                          color: Colors.red,
                          icon: Icons.warning_amber_rounded,
                          onTap: () =>
                              Navigator.pushNamed(context, "/Gov_high"),
                        ),
                        const SizedBox(
                            height: 20), // Adjust space between cards if needed
                        IssueCard(
                          title: "Mid Priority Issues",
                          color: Colors.orangeAccent,
                          icon: Icons.error_outline,
                          onTap: () => Navigator.pushNamed(context, "/Gov_mid"),
                        ),
                        const SizedBox(height: 20),
                        IssueCard(
                          title: "Low Priority Issues",
                          color: Colors.green,
                          icon: Icons.check_circle_outline,
                          onTap: () => Navigator.pushNamed(context, "/Gov_low"),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      // Use your existing BottomNavigation
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class IssueCard extends StatefulWidget {
  final String title;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const IssueCard({
    super.key,
    required this.title,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  State<IssueCard> createState() => _IssueCardState();
}

class _IssueCardState extends State<IssueCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _hoverAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 0.03, // a slight “lift” on press
    );
    _hoverAnimation =
        Tween<double>(begin: 1.0, end: 1.03).animate(_hoverController);
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _onPressDown(TapDownDetails _) {
    _hoverController.forward();
  }

  void _onPressUp(TapUpDetails _) {
    _hoverController.reverse();
  }

  void _onPressCancel() {
    _hoverController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onPressDown,
      onTapUp: _onPressUp,
      onTapCancel: _onPressCancel,
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _hoverAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF2C3E50),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 18,
                child: Icon(
                  widget.icon,
                  color: widget.color,
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
