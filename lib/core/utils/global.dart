class Var {
  static const na = "N/A";
  static const appName = "ProjectBuilder";
  static const appLogo = "assets/images/res/builder-logo.png";
  static const builder = "Build-er";
  static const ok = "OK";
  static const cancel = "Cancel";
  static const yes = "Yes";
  static const no = "No";
  static const logout = "LOGOUT";
  static const logoutMsg = "Do you wish to log out?";
  static const defaultFont = "SF Pro Rounded";
  static const ecommerce = "E-COMMERCE";
  static const about = "ABOUT";
  static const profile = "PROFILE";
  static const noImageAvailable = "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/2048px-No_image_available.svg.png";
  static const camera = "CAMERA";
  static const gallery = "GALLERY";
  static const imagesRef = "IMAGES/";
  static const permitRef = "PERMIT/";
  static const uploading = "Uploading ";
  static const uploadingPaused = "Upload is paused.";
  static const uploadingCanceled = "Upload was canceled.";
  static const uploadingError = "Uploading file error.";
  static const uploadingCompleted = "File upload successfully completed!";
  static const complete = "complete.";
  static const users = "users";
  static const jpeg = ".jpeg";
  static const uploadFromGallery = "Upload Image from Gallery";
  static const permit = "PERMIT";
  static const license = "LICENSE";
  static const dti = "DTI";
  static const sec = "SEC";
  static const upload = "Upload";
  static const createClientAccount = "Create New Client Account";
  static const createContractorAccount = "Create New Contractor Account";
  static const enterName = "Enter your Name";
  static const enterEmail = "Enter your Email";
  static const enterPassword = "Enter your Password";
  static const confirmPassword = "Confirm your Password";
  static const enterPhone = "Enter your Phone Number";
  static const enterCompany = "Enter your Company Name";
  static const enterAddress = "Enter your Address";
  static const selectLocation = "SELECT YOUR LOCATION";
  static const register = "REGISTER";
  static const validID = "Valid ID";
  static const noImageReceived = "No Image Received!";
  static const passwordMismatched = "Password Mismatched! Please re-enter your password correctly.";
  // static const aaa = "aaa";

  static charRandomizer() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch.toString();
  }
}