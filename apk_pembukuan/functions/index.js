const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

// Fungsi cek apakah user sudah login
exports.validateUserRole = functions.https.onCall((data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "User belum login");
  }

  const uid = context.auth.uid;

  // Ambil data user dari Firestore
  return admin
    .firestore()
    .collection("users")
    .doc(uid)
    .get()
    .then((doc) => {
      if (!doc.exists) {
        throw new functions.https.HttpsError(
          "not-found",
          "User tidak ditemukan"
        );
      }
      const data = doc.data();
      return {
        uid: uid,
        role: data.role || "default",
        email: data.email || "unknown",
      };
    })
    .catch((error) => {
      throw new functions.https.HttpsError("internal", error.message);
    });
});
