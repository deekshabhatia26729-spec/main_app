import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maid_app/screens/location_screen.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  // --- State Variables ---
  // Controllers for the 6 input boxes
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  // Focus nodes to manage jumping between boxes
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  // Timer state
  int _secondsRemaining = 54;
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  // --- Timer Logic ---
  void _startTimer() {
    _canResend = false;
    _secondsRemaining = 54;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  // --- Input Logic ---
  // void _onDigitChanged(String value, int index) {
    // 1. Move to NEXT box if a digit is entered
    // if (value.isNotEmpty && index < 5) {
      // _focusNodes[index + 1].requestFocus();
    // }
    // 2. Move to PREVIOUS box if backspace is pressed (handled in UI via logic below is tricky in standard widgets,
    // but standard behavior usually requires tapping.
    // For simple strict implementations, we focus on forward movement).

    // Check if all filled to auto-submit or enable button (optional)
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Theme Color (extracted from your image)
    const primaryColor = Color(0xFF7D42F1);
    const lightPurpleBg = Color(0xFFF3E8FF); // Light background for OTP boxes

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // --- 1. Top Image Section (Same as Login) ---
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.55,
            child: Image.asset(
              'assets/images/cleaning_service.jpg', // Use your existing image
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: Colors.grey[300]),
            ),
          ),

          // --- 2. Bottom Sheet Section ---
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                // Ensure it covers enough height
                constraints: BoxConstraints(minHeight: size.height * 0.5),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 32.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // --- Title Section ---
                      Text(
                        'Verify Code',
                        style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 12),

                      Text(
                        'Enter OTP to continue',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Text(
                        'Please enter 6-Digit Code -Sent to your SMS',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(
                            0xFF7D42F1,
                          ).withOpacity(0.7), // Lighter purple text
                        ),
                      ),

                      const SizedBox(height: 32),

                      // --- 3. Custom OTP Row ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(6, (index) {
                          return SizedBox(
                            width: 45, // Fixed width for square look
                            height: 50,
                            child: TextFormField(
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,

                              // Formatting
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(
                                  1,
                                ), // Limit to 1 digit
                                FilteringTextInputFormatter.digitsOnly,
                              ],

                              // Logic to jump focus
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  // If last box, unfocus (hide keyboard)
                                  if (index == 5) {
                                    _focusNodes[index].unfocus();
                                  } else {
                                    // Move to next
                                    _focusNodes[index + 1].requestFocus();
                                  }
                                } else {
                                  // If user deletes, move back (optional but good UX)
                                  if (index > 0) {
                                    _focusNodes[index - 1].requestFocus();
                                  }
                                }
                              },

                              // Styling the Box
                              style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: primaryColor,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor:
                                    lightPurpleBg, // The light purple box color
                                contentPadding:
                                    EdgeInsets.zero, // Centers text vertically
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide
                                      .none, // Remove default border lines
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: primaryColor,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 24),

                      // --- 4. Timer Text ---
                      GestureDetector(
                        onTap: () {
                          if (_canResend) {
                            _startTimer();
                            // Add logic to resend API here
                          }
                        },
                        child: Text(
                          _canResend
                              ? "Resend OTP"
                              : "Resent OTP ( 00:${_secondsRemaining.toString().padLeft(2, '0')} )",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: primaryColor,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // --- 5. Continue Button ---
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          // Inside VerifyOtpScreen...
                          onPressed: () {
                            // 1. Collect OTP
                            String otp = _controllers.map((c) => c.text).join();

                            // 2. Simple Validation
                            if (otp.length == 6) {
                              // Navigate to Location Screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LocationScreen(),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Please enter full 6-digit code",
                                  ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'Continue',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
