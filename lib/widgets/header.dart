import 'package:bruh_finance_tms/widgets/profile_pop_up.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../constants.dart';
import '../../../../controllers/MenuAppController.dart';
import '../../../../responsive.dart';
import '../controllers/user_provider.dart';
class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final imageUrl = userProvider.imageUrl ?? 'default_image_url'; // handle null case
    print(userProvider.imageUrl);

    return Padding(
      padding: const EdgeInsets.fromLTRB(2,16.0,16.0,16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (!Responsive.isDesktop(context))
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: context.read<MenuAppController>().controlMenu,
                ),
              Text(title, style: kLargeColoredBoldTextStyle),
              if (Responsive.isMobile(context))
                Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
              const Row(
                children: [
                  Icon(
                    Icons.wb_sunny_outlined,
                    color: primaryColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.notifications_none,
                    color: primaryColor,
                  ),
                  ProfileCard(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final imageUrl = userProvider.imageUrl;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ProfileDialog(userProvider: userProvider);
                },
              );
            },
            child: CircleAvatar(
              backgroundImage: imageUrl != null
                  ? NetworkImage(imageUrl)
                  : AssetImage("assets/images/profile_pic.png") as ImageProvider,
              radius: 19,
            ),
          ),
        ],
      ),
    );
  }
}
// class SearchField extends StatelessWidget {
//   const SearchField({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       decoration: InputDecoration(
//         hintText: "Search",
//         fillColor: secondaryColor,
//         filled: true,
//         border: OutlineInputBorder(
//           borderSide: BorderSide.none,
//           borderRadius: const BorderRadius.all(Radius.circular(10)),
//         ),
//         suffixIcon: InkWell(
//           onTap: () {},
//           child: Container(
//             padding: EdgeInsets.all(defaultPadding * 0.75),
//             margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
//             decoration: BoxDecoration(
//               color: primaryColor,
//               borderRadius: const BorderRadius.all(Radius.circular(10)),
//             ),
//             child: SvgPicture.asset("assets/icons/Search.svg"),
//           ),
//         ),
//       ),
//     );
//   }
// }
