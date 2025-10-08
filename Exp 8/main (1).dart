import 'package:flutter/material.dart';

void main() {
  runApp(MyCombinedApp());
}

class MyCombinedApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: DefaultTabController(
        length: 3, // number of tabs
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            title: Text("My Learning App"),
            bottom: TabBar(
              indicatorColor: Colors.amber,
              labelColor: Colors.amber,
              unselectedLabelColor: Colors.white,
              tabs: [
                Tab(icon: Icon(Icons.book), text: "Courses"),
                Tab(icon: Icon(Icons.assignment), text: "Assignments"),
                Tab(icon: Icon(Icons.person), text: "Profile"),
              ],
            ),
          ),
          drawer: Drawer(
            child: Container(
              color: Colors.deepPurple[50],
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(color: Colors.deepPurple),
                    child: Text(
                      "Navigation Menu",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.info, color: Colors.deepPurple),
                    title: Text("About App"),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings, color: Colors.deepPurple),
                    title: Text("Settings"),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout, color: Colors.deepPurple),
                    title: Text("Logout"),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
          body: TabBarView(
            children: [
              // Tab 1 - Courses
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Available Courses",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text("📘 Flutter Development"),
                    Text("💻 Web Development"),
                    Text("⚙️ Data Structures & Algorithms"),
                  ],
                ),
              ),
              // Tab 2 - Assignments
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Assignments Due",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text("1️⃣ Flutter Navigation Project - Due Tomorrow"),
                    Text("2️⃣ JavaScript DOM Exercise - Due Next Week"),
                    Text("3️⃣ Git & GitHub Report - Due in 2 Weeks"),
                  ],
                ),
              ),
              // Tab 3 - Profile
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Profile Information",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text("👤 Name: G. Srividhya"),
                    Text("📧 Email: student@example.com"),
                    Text("🎓 Course: Information Technology"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
