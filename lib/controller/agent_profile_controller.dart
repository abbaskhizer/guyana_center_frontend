// agent_profile_controller.dart ✅ GetX controller (no bindings) + small additions for tabs
import 'package:get/get.dart';
import 'package:guyana_center_frontend/modal/agent_listing.dart';

class AgentProfileController extends GetxController {
  final isVerified = true.obs;

  // tabs: 0 listings, 1 reviews, 2 contact (UI ready)
  final tabIndex = 0.obs;

  final listings = <AgentListing>[
    AgentListing(
      title: "Greenwood Estate, 4 BHK Villa",
      price: "\$1,450,000",
      image: "https://images.unsplash.com/photo-1600585154340-be6161a56a0c",
      tag: "For Sale",
    ),
    AgentListing(
      title: "Sunrise Penthouse, 3 BHK",
      price: "\$2,800/mo",
      image: "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2",
      tag: "For Rent",
    ),
    AgentListing(
      title: "Historic Cottage",
      price: "\$725,000",
      image: "https://images.unsplash.com/photo-1507089947367-19c1da9775ae",
      tag: "For Sale",
    ),
    AgentListing(
      title: "Downtown Loft Studio",
      price: "\$1,850/mo",
      image: "https://images.unsplash.com/photo-1493809842364-78817add7ffb",
      tag: "For Rent",
    ),
  ];
}
