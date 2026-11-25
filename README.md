# Spread (`miniq`) — Campus Community & Student Hub

**Spread** is a Flutter-based campus social, announcement, and grievance-redressal mobile application built for students, faculty, alumni, and campus administrators. It brings together an Instagram-inspired campus feed, peer discovery, targeted campus notifications, profile galleries, and an end-to-end complaint registration and tracking portal backed by Firebase.

---

## Key Features & Specifications

### 1. Authentication & Onboarding
- **Phone OTP Sign-In**: Passwordless mobile verification using Firebase Phone Authentication with SMS autofill support (`sms_autofill`).
- **Role-Aware Registration**: Collects student/user details including Name, College, Designation (`Student`, `Alumni`, etc.), Department, Course, Academic Year, and Interests.
- **Role-Based Navigation**: Routes standard campus users to `BottomNavigation` and administrators/approvers to `AdminBottomNavigation`.
- **Account Status Enforcement**: Checks `AccessControl` status to restrict blocked accounts cleanly across feed actions, profile updates, and connections.

### 2. Campus Feed (`FeedPage` & `CommentViewScreen`)
- **Category-Filtered Feed**: Dynamic feed tabs loaded from Firebase RTDB (`All` and category buckets).
- **Instagram-Style Interactions**:
  - Frosted smoky-blur overlay bar (`PostActionBar`) positioned cleanly over post media with like, comment count, and external **Apply** (`RegisterLink`) pills.
  - **Double-Tap to Like** with animated heart burst and **Pinch-to-Zoom** (`DoubleTapPinchImage`) with smooth snap-back.
  - **Full-Screen Image Viewer** (`FullScreenImagePage`) with `Hero` transitions and double-tap 2.5x zoom/reset.
- **Detailed Post & Live Comments**: Real-time RTDB listeners for likes and comments, live user avatar resolution (`UserAvatarCache`), keyboard-safe comment composer, and comment deletion for owners.
- **Post Creation (`Camera`)**: Pick from camera or gallery, crop images (`image_cropper`), attach descriptions & registration links, and publish to selected campus categories.

### 3. Profile & Connections
- **Profile Dashboard (`ProfileDashboard`)**:
  - Gradient-ringed circular profile photo with full-screen tap preview.
  - Live metrics for `Posts`, `Followers`, and `Role`, plus department and `#interest` tags.
  - 3-column post gallery grid (`SliverGrid`) with full-screen preview on tap and post deletion on long-press.
- **Edit Profile (`EditProfile`)**: Circular avatar cropping, Firebase Storage upload, toggleable personal details editing, and elevated role access requests (`PageRequest`) awaiting admin verification.
- **Discover People (`FriendsListPage` & `FriendsProfile`)**: Live searchable campus directory (`All` / `Connected` filters), Connect/Connected toggles synced to RTDB, and friend profile galleries (self-connect excluded).

### 4. Notifications & Campus Alerts
- Real-time campus notices (`notification_list.dart`), role-scoped publishing (`publish_notification.dart`), and local device notifications powered by `awesome_notifications`.

### 5. Complaint Registration & Tracking
- **Submit Complaints (`ComplaintRegistration`)**: Structured form capturing Subject, Recipient Authority (`Office`, `HOD`, `Principal`, etc.), Admission/Register details, and complaint body.
- **Registered Complaints (`ComplaintList`)**: Live status badges (`Processing`, `Verified`, `Rejected`, `Waiting`, `Forwarded`), complaint previews, and role-based `ToReview` views for authorities.
- **Complaint Details (`ComplaintDetails`)**: Expandable 3-step visual progress timeline (`Submitted` → `Under Review` → `Resolved`/`Rejected`), real-time official review responses, and an authorizer review composer.

### 6. Admin Panel
- Dedicated admin dashboard and tools under `lib/Screens/AdminScreen/` for access approval (`AdmAccessList`), dynamic category/list management (`AdmAddNewList`), feed moderation (`AdmFeedsManage`), complaint management (`AdmComplaintManage`), and user management (`AdmUsersList`).

---

## Tech Stack

### Frontend
| Component | Version / Detail |
| --- | --- |
| **Framework** | Flutter `3.47.6` |
| **Language** | Dart (`sdk: >=3.0.0 <4.0.0`) |
| **UI Design** | Material Design + Custom Glassmorphic / Editorial Cards |

### Key Flutter Packages (`pubspec.yaml`)
| Category | Packages |
| --- | --- |
| **Firebase** | `firebase_core ^5.2.0`, `firebase_auth ^7.1.0`, `firebase_database ^13.1.0`, `firebase_storage ^14.1.0`, `firebase_messaging ^17.1.0` |
| **Media & Images** | `cached_network_image ^4.0.7`, `image_picker ^1.2.4`, `image_cropper ^14.0.0` |
| **UI & Interactions** | `like_button ^2.0.5`, `shimmer ^4.0.0`, `expandable ^5.0.1`, `chip_list ^3.1.0`, `carousel_slider ^5.1.2`, `curved_nav_bar ^0.1.0`, `floating_frosted_bottom_bar ^0.0.1`, `flutter_slidable ^5.2.0`, `dotted_border ^3.1.0`, `cupertino_icons ^2.0.0` |
| **Platform & Utilities** | `shared_preferences ^2.0.17`, `awesome_notifications ^0.12.1`, `sms_autofill 2.4.1`, `connectivity_plus ^7.3.2`, `url_launcher ^6.1.10` |

### Android Build Configuration
| Setting | Value |
| --- | --- |
| **Application ID** | `com.example.spreadminq` |
| **Android Gradle Plugin** | `9.1.0` |
| **Gradle Wrapper** | `9.3.1` |
| **Kotlin Gradle Plugin** | `2.4.0` |
| **Java Compatibility** | `JavaVersion.VERSION_17` |
| **MultiDex** | Enabled (`multiDexEnabled = true`) |

---

## Backend Architecture (Firebase)

The backend is serverless, powered by **Firebase** (project ID `minqlite`):

1. **Firebase Authentication**
   - Phone Number + SMS OTP authentication for user sign-in and session verification.
2. **Firebase Realtime Database (`https://minqlite-default-rtdb.firebaseio.com`)**
   - `AccessControl/<phone>` — User access level, status (`active` / `blocked`), profile summary, and live avatar URL.
   - `UsersList/<college>/<phone>/<designation>` — Full user profile metadata, `Post/` gallery index, and `Friends/` connections.
   - `Feeds/<category>/<postId>` — Post content, image URL, timestamps, `Likes/<phone>`, and `Comments/<commentId>`.
   - `Complaints/<phone>/<complaintId>` & `Complaints/AdminAccess/<targetRole>/<complaintId>` — Complaint tickets, status updates, and nested `Review/<reviewId>` replies.
   - `PageRequest/<phone>` — Pending role elevation requests for admin review.
   - `AccessManagement/` — Dynamic category, designation, and complaint access options.
3. **Firebase Storage (`minqlite.firebasestorage.app`)**
   - `images/ProfileImage/<timestamp>` — Cropped circular user profile avatars.
   - Feed post media images uploaded from device camera/gallery.
4. **Cloud Messaging & Local Notifications**
   - `firebase_messaging` + `awesome_notifications` for campus alerts and notifications.

---

## Admin Panel Instructions

### 1. Granting Admin Access
Admin routing is controlled in **Firebase Realtime Database** under `AccessControl/<phone>`:
1. Register or sign in normally with the target phone number (`+91XXXXXXXXXX`).
2. Open **Firebase Console → Realtime Database → `AccessControl/<phone>`**.
3. Set:
   - `AcessCode`: `"2"` (`"1"` is standard user; `"2"` routes to the Admin Panel)
   - `AcessName`: `"Admin"` (or an authority role such as `"Principal"`, `"Hod"`, `"Hos"`, `"OfficeStaff"`, `"Reviewer"` for complaint review access)
   - `Status`: `"active"`
4. Sign out and log back in via OTP — `OtpScreen` will automatically redirect to `AdminBottomNavigation`.

### 2. Admin Navigation Tabs (`AdminBottomNavigation`)
| Tab | Screen | Purpose |
| --- | --- | --- |
| **Home** | `AdminDashboard` | Category feed preview (`Discover`) + quick-access management tiles (`Explore more`) |
| **Notification** | `NotificationList` | View and manage campus notifications |
| **RegReview** | `ComplaintList` | Switch to `ToReview` to inspect and respond to submitted complaints |
| **My Account** | `ProfileDashboard` | Admin profile, posts grid, and account settings |

### 3. Admin Management Modules (`Explore more`)
- **All feeds (`FeedManagePage`)**:
  - Filter posts by category (`All`, `Connections`, `Club`, `Event`, `Other`).
  - Tap the floating camera button to publish a new campus feed post (`Camera`).
  - Swipe left on any feed card (`Slidable` → **Delete**) to remove it from both `Feeds/<category>` and the author's `UsersList/.../Post/` node.
- **User list (`UserListPage`)**:
  - Lists registered users loaded from `AccessControl`.
  - Swipe left on a user row (`Slidable`) to **Block** (`Status: "blocked"`, restricting feed posting, connections, and profile edits) or **Unblock** (`Status: "active"`).
- **Access list (`AccessRequestPage`)**:
  - Displays pending role-elevation requests submitted by users from **Edit Profile → Request Account Access** (`PageRequest/`).
  - Select the target access level from the dropdown (`AccessManagement/AccessList`) and tap the action button to grant access.
- **Item List (`AddNewListPage`)**:
  - Manage dynamic campus lists, categories, and subcategories stored under `AccessManagement/` (feed categories, designations, and access roles).
- **Complaint Review (`RegReview` → `ComplaintDetails`)**:
  - Open any complaint assigned to your role (`To` field matching `UserType`).
  - Tap **Review Complaint**, choose a status (`Processing`, `Verified`, `Rejected`, `Waiting`, `Forwarded`), write an official reply, and tap **Submit Review**.

---

## Project Structure

```text
lib/
├── Contraints/          # SharedPreferences keys & session helpers
├── Model/               # Data models (FeedModel, CommentModel, ComplaintModel, UserListModel, GalleryModel, etc.)
├── Screens/
│   ├── AdminScreen/     # Admin management & moderation pages
│   ├── UserScreens/
│   │   ├── AdditionalScreens/   # About, Help, Privacy Policy, Verification
│   │   ├── CmpltRegistration/   # Complaint form, list & details timeline
│   │   ├── FeedScreen/          # Campus feed, detailed post & comments
│   │   ├── FriendsSuggestion/   # People discovery & friend profiles
│   │   ├── LoginScreen/         # Splash, phone login, OTP & registration
│   │   ├── NotificationScreen/  # Campus alerts feed & publisher
│   │   └── ProfileScreen/       # Profile dashboard, edit profile & gallery
│   ├── Adminbottom_navigation.dart
│   └── bottom_navigation.dart
├── Theme/               # App color palette & styling constants
├── firebase_options.dart
├── functions/           # Camera/post uploader, shared dialogs, reusable UI widgets (live avatars, zoom image viewer)
└── main.dart            # App entry point, Firebase initialization & notification channel setup
```

---

## Setup & Running Locally

1. **Prerequisites**
   - Flutter SDK `3.47.6` (Dart `>=3.0.0 <4.0.0`)
   - Android Studio / Xcode (for iOS builds) with Java 17+ toolchain
2. **Configure Firebase**
   - Ensure `android/app/google-services.json` and `lib/firebase_options.dart` match your Firebase project (`minqlite` or your own project via `flutterfire configure`).
   - Enable **Phone Authentication**, **Realtime Database**, and **Cloud Storage** in the Firebase Console.
3. **Install Dependencies & Run**
   ```bash
   flutter pub get
   flutter analyze
   flutter run
   ```
