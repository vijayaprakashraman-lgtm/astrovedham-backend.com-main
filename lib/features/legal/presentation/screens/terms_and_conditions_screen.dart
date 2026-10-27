import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:astrovedham/core/theme/app_colors.dart';
import 'package:astrovedham/widgets/common/custom_app_bar.dart';
import '../widgets/legal_content_view.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: CustomAppBar(
        title: 'legal.terms.title'.tr(),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LegalContentView(
          title: 'legal.terms.title'.tr(),
          lastUpdated: 'legal.terms.last_updated'.tr(),
          company: 'legal.terms.company'.tr(),
          sections: [
            // 1. Acceptance of Terms
            LegalSection(
              title: 'legal.terms.s1_title'.tr(),
              content: 'legal.terms.s1_body'.tr(),
            ),
            // 2. Scope of Services & Products
            LegalSection(
              title: 'legal.terms.s2_title'.tr(),
              content: 'legal.terms.s2_body'.tr(),
            ),
            // 3. Intellectual Property Rights
            LegalSection(
              title: 'legal.terms.s3_title'.tr(),
              content: 'legal.terms.s3_body'.tr(),
            ),
            // 4. User Responsibilities & Acceptable Use
            LegalSection(
              title: 'legal.terms.s4_title'.tr(),
              content: 'legal.terms.s4_intro'.tr(),
              bulletPoints: [
                'legal.terms.s4_item1'.tr(),
                'legal.terms.s4_item2'.tr(),
                'legal.terms.s4_item3'.tr(),
                'legal.terms.s4_item4'.tr(),
              ],
            ),
            // 5. Limitation of Liability & Warranties
            LegalSection(
              title: 'legal.terms.s5_title'.tr(),
              content: 'legal.terms.s5_body'.tr(),
            ),
            // 6. Governing Law & Jurisdiction
            LegalSection(
              title: 'legal.terms.s6_title'.tr(),
              content: 'legal.terms.s6_body'.tr(),
            ),

          ],
        ),
      ),
    );
  }
}
