import 'package:flutter/material.dart';
import 'package:notsy/core/commondomain/utils/extenstion/localize_money_extension.dart';
import 'package:notsy/core/utils/helper/extension_function/category_color_extension.dart';
import 'package:notsy/core/utils/helper/extension_function/size_extension.dart';

import '../../../../../core/common_presentation/bottom_navigation/wigets/responsive_text_widget.dart';
import '../../../domain/entities/person_entity/dart/person_Entity.dart';

class ResponsivePersonPaymentsCard extends StatelessWidget {
  const ResponsivePersonPaymentsCard({super.key, required this.person});
  final PersonEntity person;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xff6B7280), width: .4),
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.hardEdge,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: person.payments?.getEffectiveSummaryColor(context),
              ),
            ),

            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.w),
                  ResponsiveTextWidget(
                    textColor: Color(0xff111827),
                    text: person.name ?? "",
                    fontWeight: FontWeight.w700,
                    fontSize: 15.w,
                  ),

                  ResponsiveTextWidget(
                    text: person.phoneNumber ?? "",
                    textColor: Color(0xff6B7280),
                    fontSize: 12.w,
                    fontWeight: FontWeight.w400,
                  ),
                  for (
                    int index = 0;
                    index < (person.payments?.length ?? 0);
                    index++
                  )
                    RichText(
                      maxLines: 1, // ← constrain to a single line
                      overflow: TextOverflow
                          .ellipsis, // ← apply ellipsis at widget level
                      text: TextSpan(
                        text: person.payments?[index].category?.name ?? "",
                        style: TextStyle(
                          fontSize: 12.w,
                          color: person.payments?[index]
                              .getEffectiveSummaryColor(),

                          fontWeight: FontWeight.w400,
                          // don’t put overflow here
                        ),
                        children: [
                          TextSpan(
                            text:
                                ' ${context.money((person.payments?[index].quantity ?? 0) * (person.payments?[index].category?.cost ?? 0))}  / ${context.money(person.payments?[index].amountPaid) ?? ""}',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          // TextSpan(
                          //   text:
                          //       ' ${(person.payments?[index].amountPaid ?? 0) - (person.payments?[index].quantity ?? 0) * (person.payments?[index].category?.cost ?? 0)} ',
                          //   style: TextStyle(
                          //     color: person.payments?[index]
                          //         .getEffectiveSummaryColor(),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              child: Center(
                child:
                    (person.payments?.getEffectiveSummaryColor(context) ==
                        Colors.green)
                    ? Icon(Icons.check_circle, color: Colors.green, size: 25.w)
                    : RichText(
                        overflow: TextOverflow.ellipsis, //
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  "${person.payments?.getEffectivePaymentSummary(context).split("/").first}",
                              style: TextStyle(
                                color: person.payments
                                    ?.getEffectiveSummaryColor(context),
                                fontWeight: FontWeight.bold,
                                fontSize: 14.w,
                              ),
                            ),
                            //   TextSpan(
                            //     text:
                            //         "/${person.payments?.getEffectivePaymentSummary().split("/")[1]}",
                            //     style: TextStyle(
                            //       color: Colors.black,
                            //       fontWeight: FontWeight.w600,
                            //       fontSize: 10.w,
                            //     ),
                            //   ),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
