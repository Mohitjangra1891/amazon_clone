// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:amazon_clone/view/users/home/homepage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../controller/providers/rating_provider.dart';
import '../../../controller/services/product_services/product_service.dart';
import '../../../controller/services/rating_services.dart';
import '../../../controller/services/user_product_services.dart';
import '../../../costants/commonFunctions.dart';
import '../../../costants/constants.dart';
import '../../../models/product_model.dart';
import '../../../models/review_model.dart';
import '../../../models/user_product_model.dart';
import '../../../utils/colors.dart';

class single_product_Screen extends StatefulWidget {
  single_product_Screen({super.key, required this.productModel});
  ProductModel productModel;

  @override
  State<single_product_Screen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<single_product_Screen> {
  // ! RAZORPAY CODES (Payment Gateway)
  final razorpay = Razorpay();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
      context.read<RatingProvider>().reset();
      setState(() {
        usersRating = -1;
      });
      context
          .read<RatingProvider>()
          .checkUserRating(productID: widget.productModel.productID!);
      context
          .read<RatingProvider>()
          .checkProductPurchase(productID: widget.productModel.productID!);
    });
  }

  TextEditingController reviewTextController = TextEditingController();
  double usersRating = -1;
  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }
  //!
  //! RAZORPAY HANDLE EVENTS
  //!

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    UserProductModel userProductModel = UserProductModel(
      imagesURL: widget.productModel.imagesURL,
      name: widget.productModel.name,
      category: widget.productModel.category,
      description: widget.productModel.description,
      brandName: widget.productModel.brandName,
      manufacturerName: widget.productModel.manufacturerName,
      countryOfOrigin: widget.productModel.countryOfOrigin,
      specifications: widget.productModel.specifications,
      price: widget.productModel.price,
      discountedPrice: widget.productModel.discountedPrice,
      productID: widget.productModel.productID,
      productSellerID: widget.productModel.productSellerID,
      inStock: widget.productModel.inStock,
      discountPercentage: widget.productModel.discountPercentage,
      productCount: 1,
      time: DateTime.now(),
    );
    await ProductServices.addSalesData(
      context: context,
      productModel: userProductModel,
      userID: auth.currentUser!.phoneNumber!,
    );
    await UsersProductService.addOrder(
        context: context, productModel: userProductModel);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    commonFunctions.showErrorToast(
      context: context,
      message: 'Opps! Product Purchase Failed',
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {}

  executePayment() {
    var options = {
      'key': keyID,
      // 'amount': widget.productModel.discountedPrice! * 100,
      'amount': 1 * 100, // Amount is rs 1,
      // here amount * 100 because razorpay counts amount in paisa
      //i.e 100 paisa = 1 Rupee
      // 'image' : '<YOUR BUISNESS EMAIL>'
      'name': widget.productModel.name,
      'description': (widget.productModel.description!.length < 255)
          ? widget.productModel.description!.length
          : widget.productModel.description!.substring(0, 250),
      'prefill': {
        'contact': auth.currentUser!.phoneNumber, //<USERS CONTACT NO.>
        'email': 'test@razorpay.com' // <USERS EMAIL NO.>
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      log("error opening connection to server ${e}");
    }
  }

// !
// !
// !
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    int num = 100;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(width, height * 0.1),
        child: home_AppBar(
          width: width,
          height: height,
        ),
      ),
      body: Container(
        height: height,
        width: width,
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.03,
          vertical: height * 0.02,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarouselSlider(
                carouselController: CarouselController(),
                options: CarouselOptions(
                  height: height * 0.23,
                  autoPlay: true,
                  viewportFraction: 1,
                ),
                items: widget.productModel.imagesURL!.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        // margin: EdgeInsets.symmetric(horizontal: 5.0),

                        decoration: BoxDecoration(
                          // color: Colors.amber,
                          image: DecorationImage(
                            image: NetworkImage(i),
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              commonFunctions.blankSpace(
                height: height * 0.02,
                width: 0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Brand: ${widget.productModel.brandName}',
                    style: textTheme.labelMedium!.copyWith(color: teal),
                  ),
                  StreamBuilder(
                      stream: RatingServices.fetchReview(
                          productID: widget.productModel.productID!),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.isEmpty) {
                            return Row(
                              children: [
                                Text(
                                  '0.0',
                                  style: textTheme.labelMedium!
                                      .copyWith(color: teal),
                                ),
                                commonFunctions.blankSpace(
                                    height: 0, width: width * 0.01),
                                RatingBar(
                                  initialRating: 0,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: width * 0.04,
                                  ignoreGestures: true,
                                  ratingWidget: RatingWidget(
                                    full: Icon(
                                      Icons.star,
                                      color: amber,
                                    ),
                                    half: Icon(
                                      Icons.star_half,
                                      color: amber,
                                    ),
                                    empty: Icon(
                                      Icons.star_outline_sharp,
                                      color: amber,
                                    ),
                                  ),
                                  itemPadding: EdgeInsets.zero,
                                  onRatingUpdate: (rating) {},
                                ),
                                commonFunctions.blankSpace(
                                    height: 0, width: width * 0.02),
                                Text(
                                  '(0)',
                                  style: textTheme.labelMedium,
                                ),
                              ],
                            );
                          } else {
                            return Row(
                              children: [
                                Text(
                                  '${snapshot.data!.fold(0.0, (previousValue, product) => previousValue + (product.rating)) / snapshot.data!.length}',
                                  style: textTheme.labelMedium!
                                      .copyWith(color: teal),
                                ),
                                commonFunctions.blankSpace(
                                    height: 0, width: width * 0.01),
                                RatingBar(
                                  initialRating: snapshot.data!.fold(
                                          0.0,
                                          (previousValue, product) =>
                                              previousValue +
                                              (product.rating)) /
                                      snapshot.data!.length,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: width * 0.04,
                                  ignoreGestures: true,
                                  ratingWidget: RatingWidget(
                                    full: Icon(
                                      Icons.star,
                                      color: amber,
                                    ),
                                    half: Icon(
                                      Icons.star_half,
                                      color: amber,
                                    ),
                                    empty: Icon(
                                      Icons.star_outline_sharp,
                                      color: amber,
                                    ),
                                  ),
                                  itemPadding: EdgeInsets.zero,
                                  onRatingUpdate: (rating) {},
                                ),
                                commonFunctions.blankSpace(
                                    height: 0, width: width * 0.02),
                                Text(
                                  '(${snapshot.data!.length})',
                                  style: textTheme.labelMedium,
                                ),
                              ],
                            );
                          }
                        }
                        if (snapshot.hasError) {
                          return Row(
                            children: [
                              Text(
                                '0.0',
                                style: textTheme.labelMedium!
                                    .copyWith(color: teal),
                              ),
                              commonFunctions.blankSpace(
                                  height: 0, width: width * 0.01),
                              RatingBar(
                                initialRating: 0,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: width * 0.04,
                                ignoreGestures: true,
                                ratingWidget: RatingWidget(
                                  full: Icon(
                                    Icons.star,
                                    color: amber,
                                  ),
                                  half: Icon(
                                    Icons.star_half,
                                    color: amber,
                                  ),
                                  empty: Icon(
                                    Icons.star_outline_sharp,
                                    color: amber,
                                  ),
                                ),
                                itemPadding: EdgeInsets.zero,
                                onRatingUpdate: (rating) {},
                              ),
                              commonFunctions.blankSpace(
                                  height: 0, width: width * 0.02),
                              Text(
                                '(0)',
                                style: textTheme.labelMedium,
                              ),
                            ],
                          );
                        } else {
                          return Row(
                            children: [
                              Text(
                                '0.0',
                                style: textTheme.labelMedium!
                                    .copyWith(color: teal),
                              ),
                              commonFunctions.blankSpace(
                                  height: 0, width: width * 0.01),
                              RatingBar(
                                initialRating: 0,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: width * 0.04,
                                ignoreGestures: true,
                                ratingWidget: RatingWidget(
                                  full: Icon(
                                    Icons.star,
                                    color: amber,
                                  ),
                                  half: Icon(
                                    Icons.star_half,
                                    color: amber,
                                  ),
                                  empty: Icon(
                                    Icons.star_outline_sharp,
                                    color: amber,
                                  ),
                                ),
                                itemPadding: EdgeInsets.zero,
                                onRatingUpdate: (rating) {},
                              ),
                              commonFunctions.blankSpace(
                                  height: 0, width: width * 0.02),
                              Text(
                                '(0)',
                                style: textTheme.labelMedium,
                              ),
                            ],
                          );
                        }
                      }),
                ],
              ),
              commonFunctions.blankSpace(
                height: height * 0.01,
                width: 0,
              ),
              Text(
                widget.productModel.name!,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium!.copyWith(
                  color: black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              commonFunctions.blankSpace(
                height: height * 0.01,
                width: 0,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '-${widget.productModel.discountPercentage}%',
                      // '-${(100 - widget.productModel.discountPercentage!)}%',
                      style: textTheme.displayLarge!.copyWith(
                        color: red,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text:
                          '\t\t₹ ${widget.productModel.discountedPrice!.toStringAsFixed(0)}',
                      style: textTheme.displayLarge!.copyWith(
                        color: black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'M.R.P: ₹ ${widget.productModel.price}',
                style: textTheme.labelMedium!.copyWith(
                    color: grey, decoration: TextDecoration.lineThrough),
              ),
              commonFunctions.blankSpace(
                height: height * 0.02,
                width: 0,
              ),
              ElevatedButton(
                onPressed: () async {
                  UserProductModel model = UserProductModel(
                    imagesURL: widget.productModel.imagesURL,
                    name: widget.productModel.name,
                    category: widget.productModel.category,
                    description: widget.productModel.description,
                    brandName: widget.productModel.brandName,
                    manufacturerName: widget.productModel.manufacturerName,
                    countryOfOrigin: widget.productModel.countryOfOrigin,
                    specifications: widget.productModel.specifications,
                    price: widget.productModel.price,
                    discountedPrice: widget.productModel.discountedPrice,
                    productID: widget.productModel.productID,
                    productSellerID: widget.productModel.productSellerID,
                    inStock: widget.productModel.inStock,
                    discountPercentage: widget.productModel.discountPercentage,
                    productCount: 1,
                    time: DateTime.now(),
                  );
                  await UsersProductService.addProductToCart(
                      context: context, productModel: model);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: amber,
                  minimumSize: Size(
                    width,
                    height * 0.06,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      50,
                    ),
                  ),
                ),
                child: Text(
                  'Add to Cart',
                  style: textTheme.bodyMedium!.copyWith(color: black),
                ),
              ),
              commonFunctions.blankSpace(
                height: height * 0.01,
                width: 0,
              ),
              ElevatedButton(
                onPressed: executePayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: orange,
                  minimumSize: Size(
                    width,
                    height * 0.06,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      50,
                    ),
                  ),
                ),
                child: Text(
                  'Buy Now',
                  style: textTheme.bodyMedium!.copyWith(color: black),
                ),
              ),
              commonFunctions.blankSpace(
                height: height * 0.02,
                width: 0,
              ),
              commonFunctions.divider(),
              commonFunctions.blankSpace(
                height: height * 0.01,
                width: 0,
              ),
              Text(
                'Features',
                style: textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              commonFunctions.blankSpace(
                height: height * 0.005,
                width: 0,
              ),
              Text(
                widget.productModel.description!,
                style: textTheme.labelMedium!
                    .copyWith(fontWeight: FontWeight.w400, color: grey),
              ),
              commonFunctions.blankSpace(
                height: height * 0.02,
                width: 0,
              ),
              commonFunctions.divider(),
              commonFunctions.blankSpace(
                height: height * 0.01,
                width: 0,
              ),
              Text(
                'Specification',
                style: textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              commonFunctions.blankSpace(
                height: height * 0.005,
                width: 0,
              ),
              Text(
                widget.productModel.specifications!,
                style: textTheme.labelMedium!
                    .copyWith(fontWeight: FontWeight.w400, color: grey),
              ),
              commonFunctions.blankSpace(
                height: height * 0.02,
                width: 0,
              ),
              commonFunctions.divider(),
              commonFunctions.blankSpace(
                height: height * 0.02,
                width: 0,
              ),
              ratingWidget(textTheme, height, width),
              commonFunctions.blankSpace(
                height: height * 0.01,
                width: 0,
              ),
              Text(
                'Product Image Gallery',
                style: textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              commonFunctions.blankSpace(
                height: height * 0.01,
                width: 0,
              ),
              ListView.builder(
                  itemCount: widget.productModel.imagesURL!.length,
                  shrinkWrap: true,
                  physics: const PageScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: height * 0.001),
                      child: Image(
                        image: NetworkImage(
                          widget.productModel.imagesURL![index],
                        ),
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }

  Consumer<RatingProvider> ratingWidget(
      TextTheme textTheme, double height, double width) {
    return Consumer<RatingProvider>(builder: (context, productRating, child) {
      if (productRating.productPurchased == true) {
        return StreamBuilder(
            stream: RatingServices.fetchReview(
                productID: widget.productModel.productID!),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (productRating.userRatedTheProduct == false) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Review & Rating',
                        style: textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      commonFunctions.blankSpace(
                        height: height * 0.005,
                        width: 0,
                      ),
                      Text(
                        'Review the Product',
                        style: textTheme.labelMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      commonFunctions.blankSpace(
                        height: height * 0.005,
                        width: 0,
                      ),
                      Builder(builder: (context) {
                        if (productRating.productImages.isEmpty) {
                          return InkWell(
                            onTap: () {
                              context
                                  .read<RatingProvider>()
                                  .fetchProductImagesFromGallery(
                                      context: context);
                            },
                            child: Container(
                              height: height * 0.1,
                              width: width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_circle_outline,
                                    color: grey,
                                  ),
                                  Text(
                                    'Add Images',
                                    style: textTheme.bodyMedium!
                                        .copyWith(color: grey),
                                  )
                                ],
                              ),
                            ),
                          );
                        } else {
                          List<File> productImages =
                              productRating.productImages;
                          return GridView.builder(
                            shrinkWrap: true,
                            itemCount: productImages.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 4,
                            ),
                            itemBuilder: (context, index) {
                              return Image(
                                image: FileImage(
                                  File(
                                    productImages[index].path,
                                  ),
                                ),
                                fit: BoxFit.contain,
                              );
                            },
                          );
                        }
                      }),
                      RatingBar(
                        initialRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: width * 0.07,
                        ratingWidget: RatingWidget(
                          full: Icon(
                            Icons.star,
                            color: amber,
                          ),
                          half: Icon(
                            Icons.star_half,
                            color: amber,
                          ),
                          empty: Icon(
                            Icons.star_outline_sharp,
                            color: amber,
                          ),
                        ),
                        itemPadding: EdgeInsets.zero,
                        onRatingUpdate: (rating) {
                          usersRating = rating;
                        },
                      ),
                      commonFunctions.blankSpace(
                        height: height * 0.01,
                        width: 0,
                      ),
                      TextField(
                        controller: reviewTextController,
                        decoration: InputDecoration(
                          hintText: 'Review here',
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: width * 0.03,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                            borderSide: BorderSide(
                              color: grey,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                            borderSide: BorderSide(
                              color: grey,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                            borderSide: BorderSide(
                              color: grey,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                            borderSide: BorderSide(
                              color: amber,
                            ),
                          ),
                        ),
                      ),
                      commonFunctions.blankSpace(
                        height: height * 0.01,
                        width: 0,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          Uuid uuid = const Uuid();
                          if (usersRating >= 0) {
                            if (context
                                .read<RatingProvider>()
                                .productImages
                                .isNotEmpty) {
                              await RatingServices.uploadImageToFirebaseStorage(
                                images: context
                                    .read<RatingProvider>()
                                    .productImages,
                                context: context,
                              );

                              ReviewModel reviewModel = ReviewModel(
                                rating: usersRating,
                                imagesURL: context
                                    .read<RatingProvider>()
                                    .productImagesURL,
                                reviewID: uuid.v1(),
                                review: reviewTextController.text.trim(),
                                userID: auth.currentUser!.phoneNumber!,
                              );
                              await RatingServices.addReview(
                                context: context,
                                productID: widget.productModel.productID!,
                                reviewModel: reviewModel,
                                userID: auth.currentUser!.phoneNumber!,
                              );
                            } else {
                              ReviewModel reviewModel = ReviewModel(
                                rating: usersRating,
                                imagesURL: context
                                    .read<RatingProvider>()
                                    .productImagesURL,
                                reviewID: uuid.v1(),
                                review: reviewTextController.text.trim(),
                                userID: auth.currentUser!.phoneNumber!,
                              );
                              await RatingServices.addReview(
                                context: context,
                                productID: widget.productModel.productID!,
                                reviewModel: reviewModel,
                                userID: auth.currentUser!.phoneNumber!,
                              );
                              context.read<RatingProvider>().reset();
                              setState(() {
                                usersRating = -1;
                              });
                              context.read<RatingProvider>().checkUserRating(
                                  productID: widget.productModel.productID!);
                              context
                                  .read<RatingProvider>()
                                  .checkProductPurchase(
                                      productID:
                                          widget.productModel.productID!);
                            }
                          } else {
                            commonFunctions.showWarningToast(
                                context: context, message: 'Invalid Rating');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(
                            width,
                            height * 0.05,
                          ),
                          backgroundColor: amber,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                        ),
                        child: Text(
                          'Submit Review',
                          style: textTheme.bodyMedium,
                        ),
                      ),
                      commonFunctions.blankSpace(
                        height: height * 0.03,
                        width: 0,
                      ),
                      StreamBuilder(
                          stream: RatingServices.fetchReview(
                              productID: widget.productModel.productID!),
                          builder: (context, snapshot) {
                            log('Total Ratings =  ${snapshot.data!.length}');
                            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                              List<ReviewModel> reviewData = snapshot.data!;
                              return ListView.builder(
                                  itemCount: reviewData.length,
                                  shrinkWrap: true,
                                  physics: const PageScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    ReviewModel currentReview =
                                        reviewData[index];
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (currentReview.imagesURL!.isNotEmpty)
                                          SizedBox(
                                            height: height * 0.1,
                                            width: width,
                                            child: ListView.builder(
                                                physics:
                                                    const PageScrollPhysics(),
                                                itemCount: currentReview
                                                    .imagesURL!.length,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  return Image(
                                                    image: NetworkImage(
                                                      currentReview
                                                          .imagesURL![index],
                                                    ),
                                                  );
                                                }),
                                          ),
                                        commonFunctions.blankSpace(
                                          height: height * 0.005,
                                          width: 0,
                                        ),
                                        RatingBar(
                                          initialRating: currentReview.rating,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemSize: width * 0.04,
                                          ignoreGestures: true,
                                          ratingWidget: RatingWidget(
                                            full: Icon(
                                              Icons.star,
                                              color: amber,
                                            ),
                                            half: Icon(
                                              Icons.star_half,
                                              color: amber,
                                            ),
                                            empty: Icon(
                                              Icons.star_outline_sharp,
                                              color: amber,
                                            ),
                                          ),
                                          itemPadding: EdgeInsets.zero,
                                          onRatingUpdate: (rating) {
                                            usersRating = rating;
                                          },
                                        ),
                                        commonFunctions.blankSpace(
                                          height: height * 0.005,
                                          width: 0,
                                        ),
                                        Text(
                                          currentReview.review!,
                                          style: textTheme.labelMedium,
                                        ),
                                        commonFunctions.blankSpace(
                                          height: height * 0.02,
                                          width: 0,
                                        ),
                                        const Divider()
                                      ],
                                    );
                                  });
                            }
                            if (snapshot.hasError) {
                              return const SizedBox();
                            } else {
                              return const SizedBox();
                            }
                          })
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Review & Rating ',
                        style: textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      commonFunctions.blankSpace(
                        height: height * 0.005,
                        width: 0,
                      ),
                      StreamBuilder(
                          stream: RatingServices.fetchReview(
                              productID: widget.productModel.productID!),
                          builder: (context, snapshot) {
                            log('Total Ratings =  ${snapshot.data!.length}');
                            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                              List<ReviewModel> reviewData = snapshot.data!;
                              return ListView.builder(
                                  itemCount: reviewData.length,
                                  shrinkWrap: true,
                                  physics: const PageScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    ReviewModel currentReview =
                                        reviewData[index];
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (currentReview.imagesURL!.isNotEmpty)
                                          SizedBox(
                                            height: height * 0.1,
                                            width: width,
                                            child: ListView.builder(
                                                physics:
                                                    const PageScrollPhysics(),
                                                itemCount: currentReview
                                                    .imagesURL!.length,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  return Image(
                                                    image: NetworkImage(
                                                      currentReview
                                                          .imagesURL![index],
                                                    ),
                                                  );
                                                }),
                                          ),
                                        commonFunctions.blankSpace(
                                          height: height * 0.005,
                                          width: 0,
                                        ),
                                        RatingBar(
                                          initialRating: currentReview.rating,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemSize: width * 0.04,
                                          ignoreGestures: true,
                                          ratingWidget: RatingWidget(
                                            full: Icon(
                                              Icons.star,
                                              color: amber,
                                            ),
                                            half: Icon(
                                              Icons.star_half,
                                              color: amber,
                                            ),
                                            empty: Icon(
                                              Icons.star_outline_sharp,
                                              color: amber,
                                            ),
                                          ),
                                          itemPadding: EdgeInsets.zero,
                                          onRatingUpdate: (rating) {
                                            usersRating = rating;
                                          },
                                        ),
                                        commonFunctions.blankSpace(
                                          height: height * 0.005,
                                          width: 0,
                                        ),
                                        Text(
                                          currentReview.review!,
                                          style: textTheme.labelMedium,
                                        ),
                                        commonFunctions.blankSpace(
                                          height: height * 0.02,
                                          width: 0,
                                        ),
                                        const Divider()
                                      ],
                                    );
                                  });
                            }
                            if (snapshot.hasError) {
                              return const SizedBox();
                            } else {
                              return const SizedBox();
                            }
                          })
                    ],
                  );
                }
              }
              if (snapshot.hasError) {
                return SizedBox();
              } else {
                return const SizedBox();
              }
            });
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Review & Rating',
              style: textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            commonFunctions.blankSpace(
              height: height * 0.005,
              width: 0,
            ),
            StreamBuilder(
                stream: RatingServices.fetchReview(
                    productID: widget.productModel.productID!),
                builder: (context, snapshot) {
                  log('Total Ratings =  ${snapshot.data?.length}');
                  if (snapshot.data == null) {
                    log("review .data== null ${snapshot.data}");

                    return Text(
                      'No Ratings yet',
                      style: textTheme.labelMedium!.copyWith(color: grey),
                    );
                  }
                  if (snapshot.data!.isEmpty) {
                    log("Review .data!. isEmpty ${snapshot.data}");

                    return Text(
                      'No  Ratings yet',
                      style: textTheme.labelMedium!.copyWith(color: grey),
                    );
                  }

                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    log("review .has data ${snapshot.data}");

                    List<ReviewModel> reviewData = snapshot.data!;
                    return ListView.builder(
                        itemCount: reviewData.length,
                        shrinkWrap: true,
                        physics: const PageScrollPhysics(),
                        itemBuilder: (context, index) {
                          ReviewModel currentReview = reviewData[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (currentReview.imagesURL!.isNotEmpty)
                                GridView.builder(
                                    physics: const PageScrollPhysics(),
                                    itemCount: currentReview.imagesURL!.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 5,
                                            mainAxisExtent: 10,
                                            crossAxisSpacing: 10),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Image(
                                        image: NetworkImage(
                                          currentReview.imagesURL![index],
                                        ),
                                      );
                                    }),
                              commonFunctions.blankSpace(
                                height: height * 0.005,
                                width: 0,
                              ),
                              RatingBar(
                                initialRating: currentReview.rating,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: width * 0.04,
                                ignoreGestures: true,
                                ratingWidget: RatingWidget(
                                  full: Icon(
                                    Icons.star,
                                    color: amber,
                                  ),
                                  half: Icon(
                                    Icons.star_half,
                                    color: amber,
                                  ),
                                  empty: Icon(
                                    Icons.star_outline_sharp,
                                    color: amber,
                                  ),
                                ),
                                itemPadding: EdgeInsets.zero,
                                onRatingUpdate: (rating) {
                                  usersRating = rating;
                                },
                              ),
                              commonFunctions.blankSpace(
                                height: height * 0.005,
                                width: 0,
                              ),
                              Text(
                                currentReview.review!,
                                style: textTheme.labelMedium,
                              ),
                              commonFunctions.blankSpace(
                                height: height * 0.02,
                                width: 0,
                              ),
                            ],
                          );
                        });
                  }
                  if (snapshot.hasError) {
                    log("review ${snapshot.error}");
                    return const SizedBox();
                  } else {
                    return const SizedBox();
                  }
                }),
            commonFunctions.blankSpace(
              height: height * 0.01,
              width: 0,
            ),
            commonFunctions.divider(),
            commonFunctions.blankSpace(
              height: height * 0.01,
              width: 0,
            ),
          ],
        );
      }
    });
  }
}
