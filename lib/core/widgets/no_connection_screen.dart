import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NoConnectionScreen extends ConsumerWidget {
  const NoConnectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Illustration placeholder Using Icons instead of image for now
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 150.w,
                      height: 150.w, // Ensure it's a circle
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3F4F6),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Icon(
                      Icons.cloud_off_rounded,
                      size: 80.r,
                      color: const Color(0xFFFFA000), // Matching the yellow cloud vibe
                    ),
                  ],
                ),
                SizedBox(height: 32.h),

                // Main Title
                Text(
                  "No connection",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),

                // Subtitle
                Text(
                  "Please check your internet connectivity\nand try again",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 48.h),

                // Retry Button
                SizedBox(
                  width: 140.w,
                  height: 44.h,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Re-check connectivity — triggers stream update
                      await Connectivity().checkConnectivity();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007AFF), // Bright Blue
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                    child: Text(
                      "Retry",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
