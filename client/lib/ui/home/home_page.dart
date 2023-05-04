import 'package:dokki/constants/colors.dart';
import 'package:dokki/utils/utils.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: brandColor100),
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          Container(
            width: double.maxFinite,
            height: 220,
            decoration: const BoxDecoration(color: brandColor100),
            child: Column(
              children: [
                Text(
                  Utils.getToday(),
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 50),
                const Text(
                  "00 : 00 : 01",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: Colors.amber),
            ),
          )
        ],
      ),
    );
  }
}
