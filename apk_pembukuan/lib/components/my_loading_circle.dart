import 'package:flutter/material.dart';

/*

Loading Circle

*/

// show loading circle
void showLoadingCircle(BuildContext context) {
  // Pastikan showDialog hanya dipanggil jika widget masih ada di dalam tree
  if (Navigator.canPop(context)) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Membuat dialog tidak dapat ditutup dengan mengetuk di luar dialog
      builder: (context) => const AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

// hide loading circle
void hideLoadingCircle(BuildContext context) {
  // Pastikan Navigator.pop dipanggil hanya jika widget masih ada di dalam tree
  if (Navigator.canPop(context)) {
    Navigator.pop(context);
  }
}
