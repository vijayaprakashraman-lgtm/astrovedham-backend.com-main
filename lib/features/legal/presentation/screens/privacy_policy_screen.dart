import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:astrovedham/core/theme/app_colors.dart';
import 'package:astrovedham/widgets/common/custom_app_bar.dart';
import '../widgets/legal_content_view.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: CustomAppBar(
        title: 'legal.privacy.title'.tr(),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LegalContentView(
          title: 'legal.privacy.title'.tr(),
          lastUpdated: 'legal.privacy.last_updated'.tr(),
          company: 'legal.privacy.company'.tr(),
          sections: [
            // 1. Introduction
            LegalSection(
              title: 'legal.privacy.intro_title'.tr(),
              content: 'legal.privacy.intro_body'.tr(),
            ),
            // 2. Information We Collect
            LegalSection(
              title: 'legal.privacy.s1_title'.tr(),
              content: 'legal.privacy.s1_intro'.tr(),
              subsections: [
                LegalSubsection(
                  title: 'legal.privacy.s1_1_title'.tr(),
                  content: 'legal.privacy.s1_1_desc'.tr(),
                ),
                LegalSubsection(
                  title: 'legal.privacy.s1_2_title'.tr(),
                  content: 'legal.privacy.s1_2_desc'.tr(),
                ),
                LegalSubsection(
                  title: 'legal.privacy.s1_3_title'.tr(),
                  content: 'legal.privacy.s1_3_desc'.tr(),
                ),
              ],
            ),
            // 3. How We Use Your Information
            LegalSection(
              title: 'legal.privacy.s2_title'.tr(),
              bulletPoints: [
                'legal.privacy.s2_item1'.tr(),
                'legal.privacy.s2_item2'.tr(),
                'legal.privacy.s2_item3'.tr(),
                'legal.privacy.s2_item4'.tr(),
                'legal.privacy.s2_item5'.tr(),
              ],
            ),
            // 4. Data Protection & Security
            LegalSection(
              title: 'legal.privacy.s3_title'.tr(),
              content: 'legal.privacy.s3_body'.tr(),
              disclaimer: 'legal.privacy.s3_disclaimer'.tr(),
            ),
            // 5. Data Sharing & Disclosure
            LegalSection(
              title: 'legal.privacy.s4_title'.tr(),
              content: 'legal.privacy.s4_body'.tr(),
            ),
            // 6. Your Privacy Rights
            LegalSection(
              title: 'legal.privacy.s5_title'.tr(),
              content: 'legal.privacy.s5_body'.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
