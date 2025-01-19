// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../features/post/bloc/post_bloc.dart';
//
// class SelectedImage extends StatelessWidget {
//   const SelectedImage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<PostBloc, PostState>(
//       builder: (context, state) {
//         return state.image == null
//             ? const SizedBox.shrink()
//             : Image.memory(
//                 state.image!,
//                 fit: BoxFit.cover,
//                 height: 300,
//                 width: 300,
//               );
//       },
//     );
//   }
// }
