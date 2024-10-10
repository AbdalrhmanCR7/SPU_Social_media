import 'package:flutter/material.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {


  // final SettingsRepository _settingsRepository = SettingsRepositoryImpl();
  // UserModel? userModel;

  @override
  void initState() {
    //getUserName();
    super.initState();
  }

  // void getUserName() {
  //   _settingsRepository.getUser().then((value) {
  //     value.fold(
  //           (failure) {},
  //           (data) {
  //         WidgetsBinding.instance.addPostFrameCallback((_) {
  //           setState(() {
  //             userModel = data;
  //           });
  //         });
  //       },
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return
         Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(
            height: 190.0,
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Align(
                  alignment: AlignmentDirectional.topCenter,
                  child: Container(
                    height: 140.0,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                          4.0,
                        ),
                        topRight: Radius.circular(
                          4.0,
                        ),
                      ),
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/SPU.jpg',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                CircleAvatar(
                  radius: 64.0,
                  backgroundColor:
                  Theme.of(context).scaffoldBackgroundColor,
                  child: const CircleAvatar(
                    radius: 60.0,
                    backgroundImage: AssetImage(
                        'assets/images/Slogo.jpg'
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          // Text(
          //   userModel!.fullName,
          //   style: const TextStyle(
          //     fontWeight: FontWeight.bold,
          //     fontSize: 20,
          //   ),
          // ),
          const SizedBox(
            height: 5.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    child: Column(
                      children: [
                        Text(
                          '10',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          'Posts',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    onTap: () {},
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Column(
                      children: [
                        Text(
                          '12',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          'Photos',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    onTap: () {},
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Column(
                      children: [
                        Text(
                          '5k',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          'Followers',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    onTap: () {},
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Column(
                      children: [
                        Text(
                          '20',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          'Followings',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text(
                    'Add Photos',
                  ),
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              // OutlinedButton(
              //   onPressed: () {
              //     showDialog(
              //       context: context,
              //       builder: (_) => EditUsernameDialog(
              //         whenComplete: () {
              //           getUserName();
              //         },
              //         onStart: () {
              //           Navigator.pop(context);
              //           setState(() {
              //             userModel = null;
              //           });
              //         },
              //       ),
              //     );
              //   },
              //   child: const Icon(
              //     Icons.edit,
              //     size: 16.0,
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
