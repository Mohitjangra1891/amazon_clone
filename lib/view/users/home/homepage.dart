import 'dart:developer';

import 'package:amazon_clone/controller/services/user_data_crud_service/user_data_crud_serivice.dart';
import 'package:amazon_clone/view/users/home/product_category_screen.dart';
import 'package:amazon_clone/view/users/home/search_product_screen.dart';
import 'package:amazon_clone/view/users/home/single_product_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../controller/providers/address_provider.dart';
import '../../../controller/providers/deal_of_day_provider.dart';
import '../../../controller/services/product_services/product_service.dart';
import '../../../controller/services/user_product_services.dart';
import '../../../costants/commonFunctions.dart';
import '../../../costants/constants.dart';
import '../../../models/address_model.dart';
import '../../../models/product_model.dart';
import '../../../utils/colors.dart';
import '../address_screen/address_screen.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  CarouselController todaysDealsCarouselController = CarouselController();

  checkUserAddress() async {
    bool userAddressPresent = await userData_CRUD.checkUsersAddress();
    // log('user Address Present : ${userAddressPresent.toString()}');
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    if (userAddressPresent == false) {
      showModalBottomSheet(
          backgroundColor: transparent,
          context: context,
          builder: (context) {
            return Container(
              height: height * 0.35,
              padding: EdgeInsets.symmetric(
                  vertical: height * 0.03, horizontal: width * 0.03),
              width: width,
              decoration: BoxDecoration(
                color: white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Address',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(
                    height: height * 0.15,
                    child: ListView.builder(
                        itemCount: 1,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              if (index == 0) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AddressScreen()),
                                );
                                // Navigator.pop(context);
                              }
                            },
                            child: Container(
                              width: width * 0.35,
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.03,
                                  vertical: height * 0.01),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: greyShade3,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Builder(builder: (context) {
                                if (index == 0) {
                                  return Text(
                                    'Add Address',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black38),
                                  );
                                }
                                return Text(
                                  'Add Address',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black38),
                                );
                              }),
                            ),
                          );
                        }),
                  ),
                  commonFunctions.blankSpace(height: height * 0.06, width: 0)
                ],
              ),
            );
          });
    }
  }

  headphoneDeals(int index) {
    switch (index) {
      case 0:
        return 'Bose';
      case 1:
        return 'boAt';
      case 2:
        return 'Sony';
      case 3:
        return 'OnePlus';
    }
  }

  clothingDeals(int index) {
    switch (index) {
      case 0:
        return 'Kurtas, sarees & more';
      case 1:
        return 'Tops, dresses & more';
      case 2:
        return 'T-Shirt, jeans & more';
      case 3:
        return 'View all';
    }
  }

  // final List<Map<String, dynamic>> demoData = [
  //   {
  //     "id": 1,
  //     "title": "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops",
  //     "price": 109.95,
  //     "description":
  //         "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday",
  //     "category": "men's clothing",
  //     "image": "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg",
  //     "rating": {"rate": 3.9, "count": 120}
  //   },
  //   {
  //     "id": 2,
  //     "title": "Mens Casual Premium Slim Fit T-Shirts ",
  //     "price": 22.3,
  //     "description":
  //         "Slim-fitting style, contrast raglan long sleeve, three-button henley placket, light weight & soft fabric for breathable and comfortable wearing. And Solid stitched shirts with round neck made for durability and a great fit for casual fashion wear and diehard baseball fans. The Henley style round neckline includes a three-button placket.",
  //     "category": "men's clothing",
  //     "image":
  //         "https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg",
  //     "rating": {"rate": 4.1, "count": 259}
  //   },
  //   {
  //     "id": 3,
  //     "title": "Mens Cotton Jacket",
  //     "price": 55.99,
  //     "description":
  //         "great outerwear jackets for Spring/Autumn/Winter, suitable for many occasions, such as working, hiking, camping, mountain/rock climbing, cycling, traveling or other outdoors. Good gift choice for you or your family member. A warm hearted love to Father, husband or son in this thanksgiving or Christmas Day.",
  //     "category": "men's clothing",
  //     "image": "https://fakestoreapi.com/img/71li-ujtlUL._AC_UX679_.jpg",
  //     "rating": {"rate": 4.7, "count": 500}
  //   },
  //   {
  //     "id": 4,
  //     "title": "Mens Casual Slim Fit",
  //     "price": 15.99,
  //     "description":
  //         "The color could be slightly different between on the screen and in practice. / Please note that body builds vary by person, therefore, detailed size information should be reviewed below on the product description.",
  //     "category": "men's clothing",
  //     "image": "https://fakestoreapi.com/img/71YXzeOuslL._AC_UY879_.jpg",
  //     "rating": {"rate": 2.1, "count": 430}
  //   },
  //   {
  //     "id": 5,
  //     "title":
  //         "John Hardy Women's Legends Naga Gold & Silver Dragon Station Chain Bracelet",
  //     "price": 695,
  //     "description":
  //         "From our Legends Collection, the Naga was inspired by the mythical water dragon that protects the ocean's pearl. Wear facing inward to be bestowed with love and abundance, or outward for protection.",
  //     "category": "jewelery",
  //     "image":
  //         "https://fakestoreapi.com/img/71pWzhdJNwL._AC_UL640_QL65_ML3_.jpg",
  //     "rating": {"rate": 4.6, "count": 400}
  //   },
  //   {
  //     "id": 6,
  //     "title": "Solid Gold Petite Micropave ",
  //     "price": 168,
  //     "description":
  //         "Satisfaction Guaranteed. Return or exchange any order within 30 days.Designed and sold by Hafeez Center in the United States. Satisfaction Guaranteed. Return or exchange any order within 30 days.",
  //     "category": "jewelery",
  //     "image":
  //         "https://fakestoreapi.com/img/61sbMiUnoGL._AC_UL640_QL65_ML3_.jpg",
  //     "rating": {"rate": 3.9, "count": 70}
  //   },
  //   {
  //     "id": 7,
  //     "title": "White Gold Plated Princess",
  //     "price": 9.99,
  //     "description":
  //         "Classic Created Wedding Engagement Solitaire Diamond Promise Ring for Her. Gifts to spoil your love more for Engagement, Wedding, Anniversary, Valentine's Day...",
  //     "category": "jewelery",
  //     "image":
  //         "https://fakestoreapi.com/img/71YAIFU48IL._AC_UL640_QL65_ML3_.jpg",
  //     "rating": {"rate": 3, "count": 400}
  //   },
  //   {
  //     "id": 8,
  //     "title": "Pierced Owl Rose Gold Plated Stainless Steel Double",
  //     "price": 10.99,
  //     "description":
  //         "Rose Gold Plated Double Flared Tunnel Plug Earrings. Made of 316L Stainless Steel",
  //     "category": "jewelery",
  //     "image":
  //         "https://fakestoreapi.com/img/51UDEzMJVpL._AC_UL640_QL65_ML3_.jpg",
  //     "rating": {"rate": 1.9, "count": 100}
  //   },
  //   {
  //     "id": 9,
  //     "title": "WD 2TB Elements Portable External Hard Drive - USB 3.0 ",
  //     "price": 64,
  //     "description":
  //         "USB 3.0 and USB 2.0 Compatibility Fast data transfers Improve PC Performance High Capacity; Compatibility Formatted NTFS for Windows 10, Windows 8.1, Windows 7; Reformatting may be required for other operating systems; Compatibility may vary depending on user’s hardware configuration and operating system",
  //     "category": "electronics",
  //     "image": "https://fakestoreapi.com/img/61IBBVJvSDL._AC_SY879_.jpg",
  //     "rating": {"rate": 3.3, "count": 203}
  //   },
  //   {
  //     "id": 10,
  //     "title": "SanDisk SSD PLUS 1TB Internal SSD - SATA III 6 Gb/s",
  //     "price": 109,
  //     "description":
  //         "Easy upgrade for faster boot up, shutdown, application load and response (As compared to 5400 RPM SATA 2.5” hard drive; Based on published specifications and internal benchmarking tests using PCMark vantage scores) Boosts burst write performance, making it ideal for typical PC workloads The perfect balance of performance and reliability Read/write speeds of up to 535MB/s/450MB/s (Based on internal testing; Performance may vary depending upon drive capacity, host device, OS and application.)",
  //     "category": "electronics",
  //     "image": "https://fakestoreapi.com/img/61U7T1koQqL._AC_SX679_.jpg",
  //     "rating": {"rate": 2.9, "count": 470}
  //   },
  //   {
  //     "id": 11,
  //     "title":
  //         "Silicon Power 256GB SSD 3D NAND A55 SLC Cache Performance Boost SATA III 2.5",
  //     "price": 109,
  //     "description":
  //         "3D NAND flash are applied to deliver high transfer speeds Remarkable transfer speeds that enable faster bootup and improved overall system performance. The advanced SLC Cache Technology allows performance boost and longer lifespan 7mm slim design suitable for Ultrabooks and Ultra-slim notebooks. Supports TRIM command, Garbage Collection technology, RAID, and ECC (Error Checking & Correction) to provide the optimized performance and enhanced reliability.",
  //     "category": "electronics",
  //     "image": "https://fakestoreapi.com/img/71kWymZ+c+L._AC_SX679_.jpg",
  //     "rating": {"rate": 4.8, "count": 319}
  //   },
  //   {
  //     "id": 12,
  //     "title":
  //         "WD 4TB Gaming Drive Works with Playstation 4 Portable External Hard Drive",
  //     "price": 114,
  //     "description":
  //         "Expand your PS4 gaming experience, Play anywhere Fast and easy, setup Sleek design with high capacity, 3-year manufacturer's limited warranty",
  //     "category": "electronics",
  //     "image": "https://fakestoreapi.com/img/61mtL65D4cL._AC_SX679_.jpg",
  //     "rating": {"rate": 4.8, "count": 400}
  //   },
  //   {
  //     "id": 13,
  //     "title":
  //         "Acer SB220Q bi 21.5 inches Full HD (1920 x 1080) IPS Ultra-Thin",
  //     "price": 599,
  //     "description":
  //         "21. 5 inches Full HD (1920 x 1080) widescreen IPS display And Radeon free Sync technology. No compatibility for VESA Mount Refresh Rate: 75Hz - Using HDMI port Zero-frame design | ultra-thin | 4ms response time | IPS panel Aspect ratio - 16: 9. Color Supported - 16. 7 million colors. Brightness - 250 nit Tilt angle -5 degree to 15 degree. Horizontal viewing angle-178 degree. Vertical viewing angle-178 degree 75 hertz",
  //     "category": "electronics",
  //     "image": "https://fakestoreapi.com/img/81QpkIctqPL._AC_SX679_.jpg",
  //     "rating": {"rate": 2.9, "count": 250}
  //   },
  //   {
  //     "id": 14,
  //     "title":
  //         "Samsung 49-Inch CHG90 144Hz Curved Gaming Monitor (LC49HG90DMNXZA) – Super Ultrawide Screen QLED ",
  //     "price": 999.99,
  //     "description":
  //         "49 INCH SUPER ULTRAWIDE 32:9 CURVED GAMING MONITOR with dual 27 inch screen side by side QUANTUM DOT (QLED) TECHNOLOGY, HDR support and factory calibration provides stunningly realistic and accurate color and contrast 144HZ HIGH REFRESH RATE and 1ms ultra fast response time work to eliminate motion blur, ghosting, and reduce input lag",
  //     "category": "electronics",
  //     "image": "https://fakestoreapi.com/img/81Zt42ioCgL._AC_SX679_.jpg",
  //     "rating": {"rate": 2.2, "count": 140}
  //   },
  //   {
  //     "id": 15,
  //     "title": "BIYLACLESEN Women's 3-in-1 Snowboard Jacket Winter Coats",
  //     "price": 56.99,
  //     "description":
  //         "Note:The Jackets is US standard size, Please choose size as your usual wear Material: 100% Polyester; Detachable Liner Fabric: Warm Fleece. Detachable Functional Liner: Skin Friendly, Lightweigt and Warm.Stand Collar Liner jacket, keep you warm in cold weather. Zippered Pockets: 2 Zippered Hand Pockets, 2 Zippered Pockets on Chest (enough to keep cards or keys)and 1 Hidden Pocket Inside.Zippered Hand Pockets and Hidden Pocket keep your things secure. Humanized Design: Adjustable and Detachable Hood and Adjustable cuff to prevent the wind and water,for a comfortable fit. 3 in 1 Detachable Design provide more convenience, you can separate the coat and inner as needed, or wear it together. It is suitable for different season and help you adapt to different climates",
  //     "category": "women's clothing",
  //     "image": "https://fakestoreapi.com/img/51Y5NI-I5jL._AC_UX679_.jpg",
  //     "rating": {"rate": 2.6, "count": 235}
  //   },
  //   {
  //     "id": 16,
  //     "title":
  //         "Lock and Love Women's Removable Hooded Faux Leather Moto Biker Jacket",
  //     "price": 29.95,
  //     "description":
  //         "100% POLYURETHANE(shell) 100% POLYESTER(lining) 75% POLYESTER 25% COTTON (SWEATER), Faux leather material for style and comfort / 2 pockets of front, 2-For-One Hooded denim style faux leather jacket, Button detail on waist / Detail stitching at sides, HAND WASH ONLY / DO NOT BLEACH / LINE DRY / DO NOT IRON",
  //     "category": "women's clothing",
  //     "image": "https://fakestoreapi.com/img/81XH0e8fefL._AC_UY879_.jpg",
  //     "rating": {"rate": 2.9, "count": 340}
  //   },
  //   {
  //     "id": 17,
  //     "title": "Rain Jacket Women Windbreaker Striped Climbing Raincoats",
  //     "price": 39.99,
  //     "description":
  //         "Lightweight perfet for trip or casual wear---Long sleeve with hooded, adjustable drawstring waist design. Button and zipper front closure raincoat, fully stripes Lined and The Raincoat has 2 side pockets are a good size to hold all kinds of things, it covers the hips, and the hood is generous but doesn't overdo it.Attached Cotton Lined Hood with Adjustable Drawstrings give it a real styled look.",
  //     "category": "women's clothing",
  //     "image": "https://fakestoreapi.com/img/71HblAHs5xL._AC_UY879_-2.jpg",
  //     "rating": {"rate": 3.8, "count": 679}
  //   },
  //   {
  //     "id": 18,
  //     "title": "MBJ Women's Solid Short Sleeve Boat Neck V ",
  //     "price": 9.85,
  //     "description":
  //         "95% RAYON 5% SPANDEX, Made in USA or Imported, Do Not Bleach, Lightweight fabric with great stretch for comfort, Ribbed on sleeves and neckline / Double stitching on bottom hem",
  //     "category": "women's clothing",
  //     "image": "https://fakestoreapi.com/img/71z3kpMAYsL._AC_UY879_.jpg",
  //     "rating": {"rate": 4.7, "count": 130}
  //   },
  //   {
  //     "id": 19,
  //     "title": "Opna Women's Short Sleeve Moisture",
  //     "price": 7.95,
  //     "description":
  //         "100% Polyester, Machine wash, 100% cationic polyester interlock, Machine Wash & Pre Shrunk for a Great Fit, Lightweight, roomy and highly breathable with moisture wicking fabric which helps to keep moisture away, Soft Lightweight Fabric with comfortable V-neck collar and a slimmer fit, delivers a sleek, more feminine silhouette and Added Comfort",
  //     "category": "women's clothing",
  //     "image": "https://fakestoreapi.com/img/51eg55uWmdL._AC_UX679_.jpg",
  //     "rating": {"rate": 4.5, "count": 146}
  //   },
  //   {
  //     "id": 20,
  //     "title": "DANVOUY Womens T Shirt Casual Cotton Short",
  //     "price": 12.99,
  //     "description":
  //         "95%Cotton,5%Spandex, Features: Casual, Short Sleeve, Letter Print,V-Neck,Fashion Tees, The fabric is soft and has some stretch., Occasion: Casual/Office/Beach/School/Home/Street. Season: Spring,Summer,Autumn,Winter.",
  //     "category": "women's clothing",
  //     "image": "https://fakestoreapi.com/img/61pHAEJ4NML._AC_UX679_.jpg",
  //     "rating": {"rate": 3.6, "count": 145}
  //   }
  // ];
  // String capitalizeFirstLetter(String input) {
  //   if (input.isEmpty) {
  //     return input;
  //   }
  //   return input[0].toUpperCase() + input.substring(1);
  // }
  //
  // void adddata() async {
  //   log("message ${demoData.length}");
  //   Uuid uuid = const Uuid();
  //   String sellerID = auth.currentUser!.phoneNumber!.toString();
  //   String productID = '$sellerID${uuid.v1()}';
  //   for (int i = 0; i < demoData.length;) {
  //     String productID = '$sellerID${uuid.v1()}';
  //
  //     double d = 0;
  //     if (demoData[i]['price'] < 40) {
  //       d = 1.2;
  //     } else if (demoData[i]['price'] < 100) {
  //       d = 1.7;
  //     } else {
  //       d = 2.0;
  //     }
  //
  //     double discountedPrice = demoData[i]['price'] / d;
  //     double discountPercentage =
  //         (discountedPrice / demoData[i]['price']) * 100;
  //     try {
  //       ProductModel model = ProductModel(
  //         imagesURL: [demoData[i]['image'] ?? ""],
  //         name: demoData[i]['title'] ?? "",
  //         category:
  //             capitalizeFirstLetter(demoData[i]['category'].toString() ?? ""),
  //         description: demoData[i]['description'] ?? "",
  //         brandName: "Fastrack",
  //         manufacturerName: "",
  //         countryOfOrigin: "India",
  //         specifications:
  //             "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
  //         price: demoData[i]['price'],
  //         discountedPrice: discountedPrice,
  //         productID: productID,
  //         productSellerID: sellerID,
  //         inStock: true,
  //         uploadedAt: DateTime.now(),
  //         discountPercentage: int.parse(
  //           discountPercentage.toStringAsFixed(
  //             0,
  //           ),
  //         ),
  //       );
  //       // i++;
  //       log(i.toString());
  //       log("product$i: ${model.toMap()}");
  //       await ProductServices.addProduct(context: context, productModel: model)
  //           .whenComplete(() => i++);
  //     } catch (error) {
  //       log("errorrrrrrrrrr ${error.toString()}");
  //     }
  //   }
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkUserAddress();
      context.read<AddressProvider>().getCurrentSelectedAddress();
      context.read<DealOfTheDayProvider>().fetchTodaysDeal();
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size(width * 1, height * 0.1),
        child: home_AppBar(width: width, height: height),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HomeScreenUserAddressBar(height: height, width: width),

            commonFunctions.divider(),
            const homescreen_CategoriesList(),
            commonFunctions.blankSpace(height: height * 0.01, width: 0),
            commonFunctions.divider(),
            HomeScreenBanner(height: height),
            commonFunctions.divider(),
            TodaysDealHomeScreenWidget(
                todaysDealsCarouselController: todaysDealsCarouselController),
            commonFunctions.divider(),
            otherOfferGridWidget(
                title: 'Latest Launces in Headphones',
                textBtnName: 'Explore More',
                productPicNamesList: headphonesDeals,
                offerFor: 'headphones'),
            commonFunctions.divider(),
            // SizedBox(
            //   height: height * 0.35,
            //   width: width,
            //   child: const Image(
            //     image: AssetImage(
            //       'assets/images/offersNsponcered/insurance.png',
            //     ),
            //     fit: BoxFit.fill,
            //   ),
            // ),
            // commonFunctions.divider(),
            otherOfferGridWidget(
                title: 'Minimum 70% Off | Top Offers on Clothing',
                textBtnName: 'See all deals',
                productPicNamesList: clothingDealsList,
                offerFor: 'clothing'),
            commonFunctions.divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                commonFunctions.blankSpace(height: height * 0.01, width: 0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                  child: Text(
                    'Watch Sixer only on miniTV',
                    style: textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  // height: height * 0.4,
                  width: width,
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.03,
                    vertical: height * 0.01,
                  ),
                  child: const Image(
                    image: AssetImage(
                      'assets/images/offersNsponcered/sixer.png',
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
            commonFunctions.divider(),

            commonFunctions.blankSpace(height: height * 0.08, width: 0),
          ],
        ),
      ),
    );
  }

  // Container homescreen_user_addressBar(
  //     double height, double width, TextTheme textTheme) {
  //   return Container(
  //       height: height * 0.06,
  //       width: width,
  //       padding: EdgeInsets.symmetric(horizontal: width * 0.02),
  //       decoration: BoxDecoration(
  //         gradient: LinearGradient(
  //           colors: addressBarGradientColor,
  //           begin: Alignment.centerLeft,
  //           end: Alignment.centerRight,
  //         ),
  //       ),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         children: [
  //           Icon(
  //             Icons.location_pin,
  //             color: black,
  //           ),
  //           commonFunctions.blankSpace(
  //             height: 0,
  //             width: width * 0.02,
  //           ),
  //           Text('Deliver to user - City, State', style: textTheme.bodySmall)
  //         ],
  //       ));
  // }

  Container otherOfferGridWidget(
      {required String title,
      required String textBtnName,
      required List<String> productPicNamesList,
      required String offerFor}) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;

    return Container(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.03,
          vertical: height * 0.01,
        ),
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            commonFunctions.blankSpace(
              height: height * 0.01,
              width: 0,
            ),
            GridView.builder(
                padding: EdgeInsets.zero,
                itemCount: 4,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {},
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/offersNsponcered/${productPicNamesList[index]}'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          offerFor == 'headphones'
                              ? headphoneDeals(index)
                              : clothingDeals(index),
                          style: textTheme.bodyMedium,
                        )
                      ],
                    ),
                  );
                }),
            TextButton(
              onPressed: () {
                log("Pressed $textBtnName");
              },
              child: Text(
                textBtnName,
                style: textTheme.bodySmall!.copyWith(
                  color: blue,
                ),
              ),
            ),
          ],
        ));
  }
}

class TodaysDealHomeScreenWidget extends StatelessWidget {
  const TodaysDealHomeScreenWidget({
    super.key,
    required this.todaysDealsCarouselController,
  });

  final CarouselController todaysDealsCarouselController;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: width,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.03, vertical: height * 0.01),
        child: Consumer<DealOfTheDayProvider>(
            builder: (context, dealOfTheDayProvider, child) {
          if (dealOfTheDayProvider.dealsFetched == false) {
            return Container(
              height: height * 0.2,
              width: width,
              alignment: Alignment.center,
              child: Text(
                'Loading Latest Deals',
                style: textTheme.bodyMedium,
              ),
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${dealOfTheDayProvider.deals[3].discountPercentage}%-${dealOfTheDayProvider.deals[0].discountPercentage}% off | Latest deals.',
                  style: textTheme.displaySmall!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                commonFunctions.blankSpace(height: height * 0.01, width: 0),
                CarouselSlider(
                  carouselController: todaysDealsCarouselController,
                  options: CarouselOptions(
                    height: height * 0.2,
                    autoPlay: true,
                    viewportFraction: 1,
                  ),
                  items: dealOfTheDayProvider.deals.map((i) {
                    ProductModel currentProduct = i;
                    return Builder(
                      builder: (BuildContext context) {
                        return InkWell(
                          onTap: () async {
                            await UsersProductService.addRecentlySeenProduct(
                              context: context,
                              productModel: currentProduct,
                            );
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => single_product_Screen(
                                        productModel: currentProduct)));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: white,
                              image: DecorationImage(
                                image:
                                    NetworkImage(currentProduct.imagesURL![0]),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                commonFunctions.blankSpace(
                  height: height * 0.01,
                  width: 0,
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            5,
                          ),
                          color: red),
                      child: Text(
                        'Upto 62% Off',
                        style: textTheme.labelMedium!.copyWith(color: white),
                      ),
                    ),
                    commonFunctions.blankSpace(height: 0, width: width * 0.03),
                    Text(
                      'Deal of the Day',
                      style: textTheme.labelMedium!.copyWith(
                        color: red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                commonFunctions.blankSpace(height: height * 0.01, width: 0),
                GridView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: dealOfTheDayProvider.deals.length,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 20),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      ProductModel currentModel =
                          dealOfTheDayProvider.deals[index];
                      return InkWell(
                        onTap: () {
                          log(index.toString());
                          todaysDealsCarouselController.animateToPage(index);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: greyShade3,
                            ),
                            image: DecorationImage(
                              image: NetworkImage(currentModel.imagesURL![0]),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      );
                    }),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'See all Deals',
                    style: textTheme.bodySmall!.copyWith(
                      color: blue,
                    ),
                  ),
                ),
              ],
            );
          }
        }),
      ),
    );
  }
}

class HomeScreenUserAddressBar extends StatelessWidget {
  const HomeScreenUserAddressBar({
    super.key,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      height: height * 0.06,
      width: width,
      padding: EdgeInsets.symmetric(horizontal: width * 0.02),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: addressBarGradientColor,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child:
          Consumer<AddressProvider>(builder: (context, addressProvider, child) {
        if (addressProvider.fetchedCurrentSelectedAddress &&
            addressProvider.addressPresent) {
          AddressModel selectedAddress = addressProvider.currentSelectedAddress;
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.location_pin,
                color: black,
              ),
              commonFunctions.blankSpace(
                height: 0,
                width: width * 0.02,
              ),
              Text(
                'Deliver to ${selectedAddress.name} - ${selectedAddress.town}, ${selectedAddress.state}',
                style: textTheme.bodySmall,
              )
            ],
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.location_pin,
                color: black,
              ),
              commonFunctions.blankSpace(
                height: 0,
                width: width * 0.02,
              ),
              Text('Deliver to user - City, State', style: textTheme.bodySmall)
            ],
          );
        }
      }),
    );
  }
}

class HomeScreenBanner extends StatelessWidget {
  const HomeScreenBanner({
    super.key,
    required this.height,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      carouselController: CarouselController(),
      options: CarouselOptions(
        height: height * 0.24,
        autoPlay: true,
        viewportFraction: 1,
      ),
      items: carouselPictures.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              // margin: EdgeInsets.symmetric(horizontal: 5.0),

              decoration: BoxDecoration(
                color: Colors.amber,
                image: DecorationImage(
                  image: AssetImage('assets/images/carousel_slideshow/$i'),
                  fit: BoxFit.fill,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

class homescreen_CategoriesList extends StatelessWidget {
  const homescreen_CategoriesList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: height * 0.10,
      width: width,
      child: ListView.builder(
        itemCount: categories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProductCategoryScreen(productCategory: categories[index]),
                ),
              );
              log("category item pressed : ${categories[index]}");
            },
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: width * 0.02,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image(
                    image: AssetImage(
                      'assets/images/categories/${categories[index]}.png',
                    ),
                    height: height * 0.07,
                  ),
                  Text(
                    categories[index],
                    style: textTheme.labelMedium,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class home_AppBar extends StatelessWidget {
  const home_AppBar({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(),

      padding: EdgeInsets.only(
          left: width * 0.03,
          right: width * 0.03,
          bottom: height * 0.012,
          top: height * 0.05),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: appBarGradientColor,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchedProductScreen(),
                ),
              );
              print("searched pressed");
              log("x");
            },
            child: Container(
              width: width * 0.81,
              height: height * 0.06,
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.04,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  5,
                ),
                border: Border.all(
                  color: grey,
                ),
                color: white,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: black,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: width * 0.03,
                    ),
                    child: Text(
                      'Search Amazon.in',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: grey),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.camera_alt_outlined,
                    color: grey,
                  ),
                ],
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                // ProductServices.getImages(context: context);
              },
              icon: Icon(
                Icons.mic,
                color: black,
              ))
        ],
      ),
    );
  }
}
