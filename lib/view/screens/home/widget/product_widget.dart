import 'package:citgroupvn_efood_table/controller/cart_controller.dart';
import 'package:citgroupvn_efood_table/controller/product_controller.dart';
import 'package:citgroupvn_efood_table/controller/splash_controller.dart';
import 'package:citgroupvn_efood_table/data/model/response/product_model.dart';
import 'package:citgroupvn_efood_table/helper/price_converter.dart';
import 'package:citgroupvn_efood_table/helper/route_helper.dart';
import 'package:citgroupvn_efood_table/util/dimensions.dart';
import 'package:citgroupvn_efood_table/util/styles.dart';
import 'package:citgroupvn_efood_table/view/base/custom_image.dart';
import 'package:citgroupvn_efood_table/view/base/stock_tag_view.dart';
import 'package:citgroupvn_efood_table/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:citgroupvn_efood_table/view/screens/home/widget/price_stack_tag.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProductWidget extends StatefulWidget {
  final Product product;

  const ProductWidget({
    super.key,
    required this.product,
  });

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return GetBuilder<CartController>(builder: (cartController) {
      return GetBuilder<ProductController>(builder: (productController) {
        late int cartIndex;

        DateTime currentTime = Get.find<SplashController>().currentTime;
        DateTime start =
            DateFormat('hh:mm:ss').parse(widget.product.availableTimeStarts!);
        DateTime end =
            DateFormat('hh:mm:ss').parse(widget.product.availableTimeEnds!);
        DateTime startTime = DateTime(currentTime.year, currentTime.month,
            currentTime.day, start.hour, start.minute, start.second);
        DateTime endTime = DateTime(currentTime.year, currentTime.month,
            currentTime.day, end.hour, end.minute, end.second);
        if (endTime.isBefore(startTime)) {
          endTime = endTime.add(const Duration(days: 1));
        }
        bool isAvailable =
            currentTime.isAfter(startTime) && currentTime.isBefore(endTime);

        cartIndex = cartController.getCartIndex(widget.product);
        double productPrice = widget.product.price ?? 0;
        if (widget.product.branchProduct != null) {
          productPrice = widget.product.branchProduct?.price ?? 0;
        }

        return InkWell(
          onTap: () => RouteHelper.openDialog(
              context,
              ProductBottomSheet(
                product: widget.product,
              )),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: cartIndex != -1
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: cartIndex != -1
                          ? Theme.of(context).primaryColor.withOpacity(0.1)
                          : Get.isDarkMode
                              ? Theme.of(context).cardColor.withOpacity(0.1)
                              : Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 3.75),
                      blurRadius: 9.29,
                    )
                  ],
                ),
                child: Column(children: [
                  const SizedBox(height: 3),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeSmall),
                        child: Text(widget.product.name ?? '',
                            style: robotoRegular.copyWith(
                              fontSize: (width > 590 && width < 650)
                                  ? Dimensions.paddingSizeSmall
                                  : Dimensions.paddingSizeDefault,
                              color: cartIndex != -1
                                  ? Colors.white
                                  : Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .color,
                            ),
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                      child: Stack(
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                child: CustomImage(
                                  height: double.infinity,
                                  width: double.infinity,
                                  image:
                                      '${Get.find<SplashController>().configModel?.baseUrls?.productImageUrl}/${widget.product.image}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              if (cartIndex != -1)
                                Positioned(
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.3),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                    ),
                                    padding: EdgeInsets.only(
                                        bottom: Dimensions.paddingSizeDefault),
                                    child: Center(
                                      child: Text(
                                        '${'qty'.tr} : ${cartController.getCartQty(widget.product)}',
                                        style: robotoBold.copyWith(
                                          fontSize: Dimensions.fontSizeLarge,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              PriceStackTag(
                                value: PriceConverter.convertPrice(
                                    double.parse('$productPrice')),
                              )
                            ],
                          ),
                          StockTagView(product: widget.product),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
              if (!isAvailable)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5),
                    ),
                    color: Colors.black.withOpacity(0.7),
                    // color:Theme.of(context).textTheme.bodyText1?.color?.withOpacity(0.7),
                    boxShadow: [
                      BoxShadow(
                        // color: Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.1),
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 9.23,
                        offset: const Offset(0, 3.71),
                      )
                    ],
                  ),
                  child: Center(
                      child: Text(
                    'not_available'.tr.replaceAll(' ', '\n'),
                    style: robotoBold.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  )),
                ),
            ],
          ),
        );
      });
    });
  }
}
