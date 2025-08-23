import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:meme_verse/app/core/theme/color/app_colors.dart';

class CustomWidgets {
  static Widget customButton({
    required String label,
    required VoidCallback onPressed,
    Color? primaryColor = AppColors.PRIMARY_COLOR,
    Color? secondaryColor = AppColors.SECONDARY_COLOR,
  }) {
    return Animate(
      effects: [ ScaleEffect(duration: Duration(milliseconds: 1000))],
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFF2B2B2B), // Dark gray for better contrast
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          side: BorderSide(color: primaryColor!, width: 2),
          elevation: 4,
          shadowColor: primaryColor.withOpacity(0.5),
        ),
        onPressed: onPressed,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [primaryColor, secondaryColor!]),
            borderRadius: BorderRadius.circular(24),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2B2B2B), // Dark gray text for readability
            ),
          ),
        ),
      ),
    );
  }

  static Widget customMemeCard({
    required String imageUrl,
    required String caption,
    required VoidCallback onTap,
    bool isTrending = false,
  }) {
    return Animate(
      effects: [ShakeEffect(duration: Duration(milliseconds: 200), hz: 4)],
      child: InkWell(
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          color: AppColors.GRAY_WHITE_COLOR,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(Icons.error, color: AppColors.RED_COLOR),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  caption,
                  style: GoogleFonts.poppins(
                    color: isTrending ? AppColors.SECONDARY_COLOR : AppColors.WHITE_COLOR,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: Duration(milliseconds: 300)).scale(),
      ),
    );
  }

  static Widget customTextField({
    required TextEditingController controller,
    required String label,
    Color borderColor = AppColors.PRIMARY_COLOR,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: AppColors.HINT_TEXT_COLOR),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 3),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: AppColors.GRAY_WHITE_COLOR,
      ),
      style: GoogleFonts.poppins(color: AppColors.WHITE_COLOR),
    );
  }

  static Widget customLottieLoader() {
    return Lottie.asset(
      'assets/loader/meme_loader.json', // Meme-themed Lottie (e.g., dancing Pepe)
      width: 100,
      height: 100,
    );
  }
}