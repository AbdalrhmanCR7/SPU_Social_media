import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? profileImage; // متغير لتخزين رابط الصورة الشخصية
  String coverImage = 'assets/images/SPU.jpg'; // صورة الغلاف الافتراضية



  // دالة لعرض خيارات الصورة الشخصية
  void showOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('تعديل الصورة الشخصية'),
                onTap: () {
                  // هنا يمكنك إضافة الكود لتعديل الصورة الشخصية
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('حذف الصورة الشخصية'),
                onTap: () {
                  setState(() {
                    profileImage = null; // إزالة الصورة الشخصية
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.visibility),
                title: const Text('عرض الصورة الشخصية'),
                onTap: () {
                  showFullImage(profileImage ??
                      'assets/images/Slogo.jpg'); // عرض الصورة الشخصية
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // دالة لعرض خيارات صورة الغلاف
  void showCoverOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('تعديل صورة الغلاف'),
                onTap: () {
                  // هنا يمكنك إضافة الكود لتعديل صورة الغلاف
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('حذف صورة الغلاف'),
                onTap: () {
                  // هنا يمكنك إضافة الكود لحذف صورة الغلاف
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.visibility),
                title: const Text('عرض صورة الغلاف'),
                onTap: () {
                  showFullImage(coverImage); // عرض صورة الغلاف
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // دالة لعرض الصورة بشكل أكبر
  void showFullImage(String imagePath) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop(); // أغلق الحوار عند الضغط
            },
            child: Center(
              child: Hero(
                tag: 'profileImageHero', // استخدم Hero للتأثير
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  child: GestureDetector(
                    onTap: showCoverOptions,
                    // استدعاء دالة عرض خيارات صورة الغلاف عند الضغط
                    child: Container(
                      height: 140.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                        image: DecorationImage(
                          image: AssetImage(coverImage), // استخدام صورة الغلاف
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: showOptions,
                  // استدعاء دالة عرض الخيارات عند الضغط على الصورة الشخصية
                  onLongPress: () {
                    // عند الضغط المطول عرض الصورة بشكل أكبر
                    showFullImage(profileImage ?? 'assets/images/Slogo.jpg');
                  },
                  child: CircleAvatar(
                    radius: 64.0,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: Hero(
                      tag: 'profileImageHero', // استخدم Hero للتأثير
                      child: CircleAvatar(
                        radius: 60.0,
                        backgroundImage: profileImage != null
                            ? AssetImage(
                                profileImage!) // استخدام الصورة إذا كانت موجودة
                            : const AssetImage(
                                'assets/images/Slogo.jpg'), // الصورة الافتراضية
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5.0),
          const Text(
            'User name', // استبدل بنص اسم المستخدم الفعلي
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 5.0),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
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
                  child: const Text('Add Photos'),
                ),
              ),
              const SizedBox(width: 10.0),
            ],
          ),
        ],
      ),
    );
  }
}
