import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/profile_bloc.dart';
import '../../bloc/profile_event.dart';
import '../../bloc/profile_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}
class _ProfilePageState extends State<ProfilePage> {

  final TextEditingController _bioController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is LoadedState) {
                  _bioController.text = state.profileUser.bio ?? ""; // Load bio
                  return Center(
                    child: Text(
                      state.profileUser.userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  );
                } else {
                  return const Center(child: Text('Loading...'));
                }
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
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
            const Text(
              'User Name',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is LoadedState) {
                  return Text(
                    state.profileUser.bio ?? "No bio",
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  );
                } else {
                  return const Text(
                    'Loading bio...',
                    style: TextStyle(

                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
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
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                ),
                itemCount: 3,
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
      builder: (_) {
        return BlocProvider.value(
          value: context.read<ProfileBloc>(),
          child: AlertDialog(
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
                  TextField(
                    controller: _bioController, // Use controller for bio
                    decoration: const InputDecoration(
                      hintText: 'Enter your bio',
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
                  final updatedProfile = (context
                      .read<ProfileBloc>()
                      .state as LoadedState)
                      .profileUser
                      .copyWith(newBio: _bioController.text);
                  context.read<ProfileBloc>().add(
                      UpdateUserProfile(updatedProfile));
                  Navigator.of(context).pop();
                },
                child: const Text('Save'),

              )

            ],
          ),
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
