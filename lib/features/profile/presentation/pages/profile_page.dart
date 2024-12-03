import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../register/bloc/register_bloc.dart';
import '../../bloc/profile_bloc.dart';

class ProfilePage extends StatefulWidget {
  final String? uid;

  const ProfilePage({super.key, this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final registerBloc = context.read<RegisterBloc>();
  late final profileBloc = context.read<ProfileBloc>();

  @override
  Widget build(BuildContext context) {

        return Scaffold(
          appBar: AppBar(
            title: const Text('qq'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // صورة البروفايل
                    GestureDetector(
                      onLongPress: () {
                        _showProfilePictureDialog(context);
                      },
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // إحصائيات (منشورات، متابعين، متابع)
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatColumn('Posts', '50'),
                          _buildStatColumn('Followers', '1.2K'),
                          _buildStatColumn('Following', '150'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // اسم المستخدم والبايو
                const Text(
                  'User Name',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 16),
                // أزرار التفاعل
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _showEditProfileDialog(context);
                        },
                        child: const Text('Edit Profile'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text('Share Profile'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // الشبكة (placeholder للمشاركات)
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                    ),
                    itemCount: 3, // عدد العناصر
                    itemBuilder: (context, index) {
                      return Container(
                        color: Colors.grey[300],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );

  }

  Widget _buildStatColumn(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Edit Profile Picture:'),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Change Profile Picture'),
                ),
                const SizedBox(height: 16),
                const Text('Edit Bio:'),
                const TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter your bio',
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Edit Username:'),
                const TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter your username',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Save changes logic here
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showProfilePictureDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                SizedBox(height: 16),
                Text(
                  'User Name',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
