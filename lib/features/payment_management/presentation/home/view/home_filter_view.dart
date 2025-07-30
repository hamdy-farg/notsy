import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:notsy/core/baseComponents/base_responsive_widget.dart';
import 'package:notsy/core/baseComponents/base_view_model_view.dart';
import 'package:notsy/core/common_presentation/bottom_navigation/wigets/custom_snackBarWidget.dart';
import 'package:notsy/core/commondomain/entities/based_api_result_models/api_result_model.dart';
import 'package:notsy/core/commondomain/utils/extenstion/category_color_extension.dart';
import 'package:notsy/core/utils/helper/extension_function/size_extension.dart';
import 'package:notsy/features/payment_management/domain/entities/payment_entities/category_entity.dart';
import 'package:notsy/features/payment_management/presentation/add_new_payment/view/add_new_payment_view.dart';
import 'package:notsy/features/payment_management/presentation/home/payment_filter_view_model.dart';
import 'package:provider/provider.dart';

import '../../../../../core/di/app_component/app_component.dart';
import '../../../../../core/utils/helper/extension_function/responsive_ui_helper/responsive_config.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/entities/person_entity/dart/person_Entity.dart';
import '../../add_new_payment/add_new_payment_view_model.dart';
import '../widgets/responsive_person_payments_card.dart';

class HomeFilterView extends StatefulWidget {
  HomeFilterView({super.key});

  @override
  State<HomeFilterView> createState() => _HomeFilterViewState();
}

class _HomeFilterViewState extends State<HomeFilterView> {
  //
  List<CategoryEntity> _category_list = <CategoryEntity>[
    CategoryEntity(name: "All", originalColorValue: "2E7D32"),
  ];

  //
  Timer? _debounce;

  HomePaymentFilterViewModel? _provider;
  void _listenToLocalPaymentList() {
    _provider?.payemnt_list_result.stream.listen((
      ApiResultModel<List<PersonEntity>> result,
    ) {
      // log("listener is on $result");
      if (result is Success<List<PersonEntity>>) {
        final rank = _provider?.paymentList;
        _provider?.paymentList = (result.data);

        // log("new PaymentList : ${_provider?.paymentList}");
      } else {
        showAppSnack(context, "there is error please try again");
      }
    });
  }

  void _listenToAllPaymentCategory() async {
    _provider?.category_list_result.stream.listen((
      ApiResultModel<List<CategoryEntity>> result,
    ) {
      if (result is Success<List<CategoryEntity>>) {
        _category_list.clear();
        _category_list.add(
          CategoryEntity(name: "All", originalColorValue: "2E7D32"),
        );
        _category_list.addAll(result.data);
        // log("activated now ${_category_list}");
      } else {
        showAppSnack(context, "there is error please try agian");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return BaseResponsiveWidget(
      initializeConfig: true,
      buildWidget: (BuildContext context, ResponsiveUiConfig responsiveUiConfig) => Scaffold(
        body: SafeArea(
          child: BaseViewModelView<HomePaymentFilterViewModel>(
            needLoader: false,
            onInitState: (HomePaymentFilterViewModel provider) async {
              if (_provider != null) return; // prevent re-initializing
              _provider = provider;

              _listenToLocalPaymentList();

              _listenToAllPaymentCategory();
              // provider.pagingController.refresh();
              provider.currentPage.value = 1;
            },
            buildWidget: (HomePaymentFilterViewModel provider) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        SizedBox(height: 10.h, width: 10.w),
                        Text(
                          '${t?.payments}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20.w,
                            letterSpacing: -0.5,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    ChangeNotifierProvider<
                                      AddNewPaymentViewModel
                                    >(
                                      create: (BuildContext context) =>
                                          locator<AddNewPaymentViewModel>(),
                                      child: AddNewPaymentView(isEdited: false),
                                    ),
                              ),
                            );

                            //
                            if (result == "refresh") {
                              _provider?.pagingController.refresh();
                              _provider?.currentPage.value = 1;
                              await _provider?.getAllPaymentCategory();
                            }
                            //
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 1,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.w),
                              border: Border.all(
                                color: Color(0xFF2E7D32),
                                width: 3,
                              ),
                            ),
                            child: Icon(
                              Icons.add,
                              color: Color(0xFF2E7D32),
                              size: 25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    child: TextFormField(
                      controller: provider.searchController,
                      onChanged: (value) async {
                        if (_debounce?.isActive ?? false) _debounce!.cancel();
                        _debounce = Timer(
                          const Duration(milliseconds: 300),
                          () {
                            _provider?.pagingController.refresh();
                            _provider?.currentPage.value = 1;
                          },
                        );

                        // provider.filterPaymentInfo();
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Color(0xff6B7280),
                          size: 24.w,
                        ),
                        hintText: "${t?.searchByNameOrPhone}",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.w,
                          color: Color(0xffD1D5DB),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.w),

                          borderSide: BorderSide(
                            width: 1,
                            color: Color(0xffD1D5DB),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.w),

                          borderSide: BorderSide(
                            width: 1,
                            color: Color(0xffD1D5DB),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.w),

                          borderSide: BorderSide(
                            width: 1,
                            color: Color(0xffD1D5DB),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          offset: Offset(0, 6),
                          // larger offset to push it down
                          blurRadius: 6,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    width: double.infinity,
                    padding: EdgeInsets.only(right: 16, bottom: 12, left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${t?.filterByStatusAndCategory}",
                          style: TextStyle(
                            color: Color(0xff4B5563),
                            fontSize: 14.w,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        SizedBox(
                          height: 33.h,

                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: _category_list.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  // log(
                                  //   "categorys ${provider.selectedCategoryName.value ?? ""}",
                                  // );

                                  // log("categorys ${_category_list ?? ""}");
                                  final current = List<String>.from(
                                    provider.selectedCategoryName.value,
                                  );

                                  // log("categorys ${_category_list ?? ""}");
                                  if (!provider.selectedCategoryName.value
                                      .contains(_category_list[index].name)) {
                                    //
                                    current.add(
                                      _category_list[index].name ?? "",
                                    );
                                    if (_category_list[index].name != "All") {
                                      current.remove("All");
                                    }
                                    if (_category_list[index].name == "All") {
                                      current.clear();
                                      current.add(
                                        _category_list[index].name ?? "",
                                      );
                                    }
                                  } else {
                                    //
                                    current.remove(_category_list[index].name);
                                    if (current.isEmpty) {
                                      current.add("All");
                                    } //
                                  }
                                  _provider?.pagingController.refresh();
                                  provider.selectedCategoryName.value = current;
                                  _provider?.currentPage.value = 1;
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),

                                  decoration: BoxDecoration(
                                    color:
                                        provider.selectedCategoryName.value
                                            .contains(
                                              _category_list[index].name,
                                            )
                                        ? Color(
                                            _category_list[index]
                                                .originalColorToColorValue(),
                                          )
                                        : Color(
                                            _category_list[index]
                                                .originalColorToColorValue(),
                                          ).withOpacity(.2),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      width: 1,
                                      color: Color(
                                        _category_list[index]
                                            .originalColorToColorValue(),
                                      ),
                                    ),
                                  ),

                                  margin: EdgeInsets.only(left: 8.w),
                                  child: Text(
                                    "${_category_list[index].name}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13.w,
                                      color:
                                          provider.selectedCategoryName.value
                                              .contains(
                                                _category_list[index].name,
                                              )
                                          ? Colors.white
                                          : Color(
                                              _category_list[index]
                                                  .originalColorToColorValue(),
                                            ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      color: Colors.white,
                      backgroundColor: Color(0xff2E7D32),
                      onRefresh: () async {
                        _provider?.pagingController.refresh();
                        _provider?.currentPage.value = 1;

                        // log("_payment list${_paymentList}");
                        await _provider!.getAllPaymentCategory();
                      },
                      child: PagingListener(
                        controller: _provider!.pagingController,
                        builder: (context, state, fetchNextPage) {
                          return PagedListView<int, PersonEntity>(
                            state: state,
                            fetchNextPage: fetchNextPage,
                            builderDelegate: PagedChildBuilderDelegate(
                              itemBuilder: (context, person, index) {
                                // log("persons $person");
                                return GestureDetector(
                                  onTap: () async {
                                    final result = await Navigator.of(context)
                                        .push(
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                ChangeNotifierProvider<
                                                  AddNewPaymentViewModel
                                                >(
                                                  create:
                                                      (BuildContext context) =>
                                                          locator<
                                                            AddNewPaymentViewModel
                                                          >(),
                                                  child: AddNewPaymentView(
                                                    isEdited: true,
                                                    personEntity: person,
                                                  ),
                                                ),
                                          ),
                                        );

                                    //
                                    if (result == "refresh") {
                                      _provider?.pagingController.refresh();
                                      _provider?.currentPage.value = 1;
                                      await _provider?.getAllPaymentCategory();
                                    }
                                  },
                                  child: ResponsivePersonPaymentsCard(
                                    person: person,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// void scrollableListener() {
//   _scrollController.addListener(() {
//     final thresholdPixels = 200;
//
//     if (_scrollController.position.pixels >=
//             _scrollController.position.maxScrollExtent - thresholdPixels &&
//         !_isLastPage) {
//       log("Loading next page: ${_provider!.currentPage.value + 1}");
//       _provider!.currentPage.value += 1;
//       // You should check if the newly loaded data length is less than page size to set _isLastPage elsewhere
//       if (_paymentList == []) {
//         log("messageeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
//         _isLastPage = true;
//       }
//     }
//   });
// }
//
// Container(
//   key: ValueKey(person.id),
//   padding: EdgeInsets.all(12),
//   margin: EdgeInsets.only(
//     bottom: 8,
//     right: 8.w,
//     left: 8.w,
//   ),
//   decoration: BoxDecoration(
//     color: Color(
//       person.payments
//               ?.getEffectivePaymentColor() ??
//           0,
//     ).withOpacity(.09),
//     borderRadius: BorderRadius.circular(12),
//     border: Border.all(
//       color: Color(
//         person.payments
//                 ?.getEffectivePaymentColor() ??
//             0,
//       ),
//       width: 1.3,
//     ),
//   ),
//   child: Row(
//     mainAxisAlignment:
//         MainAxisAlignment.spaceBetween,
//     children: [
//       Column(
//         crossAxisAlignment:
//             CrossAxisAlignment.start,
//         mainAxisAlignment:
//             MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             "${person.name}",
//             style: TextStyle(
//               color: Color(0xff111827),
//               fontWeight: FontWeight.w500,
//               fontSize: 14.w,
//             ),
//           ),
//           Text(
//             "${person.phoneNumber}",
//             style: TextStyle(
//               color: Color(0xff6B7280),
//               fontWeight: FontWeight.w400,
//               fontSize: 12.w,
//             ),
//           ),
//
//           Text(
//             "${person?.payments?.map((e) => e.category?.name).toList().join(",")}",
//             style: TextStyle(
//               color: Color(0xff6B7280),
//               fontWeight: FontWeight.w400,
//               fontSize: 12.w,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//       Column(
//         mainAxisAlignment:
//             MainAxisAlignment.center,
//         crossAxisAlignment:
//             CrossAxisAlignment.end,
//         children: [
//           RichText(
//             text: TextSpan(
//               children: [
//                 TextSpan(
//                   text:
//                       "${person.payments?.getEffectivePaymentAmount().split("//")[0]}",
//                   style: TextStyle(
//                     color: Color(
//                       person.payments
//                               ?.getEffectivePaymentColor() ??
//                           0,
//                     ),
//                     fontWeight:
//                         FontWeight.w600,
//                     fontSize: 13.w,
//                   ),
//                 ),
//                 TextSpan(
//                   text:
//                       "${person.payments?.getEffectivePaymentAmount().split("//")[1]}",
//                   style: TextStyle(
//                     color: Color(0xff6B7280),
//                     fontWeight:
//                         FontWeight.w400,
//                     fontSize: 11.w,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           Text(
//             "${person.payments?.getEffectivePaymentDescription()}",
//             style: TextStyle(
//               color: Color(
//                 person.payments
//                         ?.getEffectivePaymentColor() ??
//                     0,
//               ),
//               fontWeight: FontWeight.w400,
//               fontSize: 12.w,
//             ),
//           ),
//         ],
//       ),
//     ],
//   ),
// ),
