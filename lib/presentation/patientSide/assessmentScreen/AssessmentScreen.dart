import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import 'package:smart_clinic_for_psychiatry/presentation/common/components/appTheme/my_theme.dart';
import 'package:smart_clinic_for_psychiatry/presentation/patientSide/assessmentScreen/AssessmentTitle.dart';
import 'package:smart_clinic_for_psychiatry/presentation/patientSide/assessmentScreen/Questions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key});

  static const String routeName = 'AssessmentScreen';

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  late Future<void> _loadingData;

  @override
  void initState() {
    super.initState();
    _loadingData = _loadData();
  }

  Future<void> _loadData() async {
    // Simulate loading data here if necessary
    await Future.delayed(Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _loadingData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: MyTheme.primaryLight,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return _buildScreenContent();
          }
        },
      ),
    );
  }

  Widget _buildScreenContent() {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 3,
                    width: 0.90 * MediaQuery.of(context).size.width,
                    child: FadeInLeft(
                      child: Image(
                        image: AssetImage('assets/images/assessment.png'),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 40),
                  Text(
                    AppLocalizations.of(context)!.choose_self_assessment_test_based_on_the_following_disorders,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: MyTheme.primaryLight,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 20),
                  AssessmentTile(
                    title: AppLocalizations.of(context)!.depression,
                    questions: DepressionQuestions.getQuestions(context),
                    colors: [MyTheme.primaryLight, MyTheme.backgroundButtonColor],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 60),
                  AssessmentTile(
                    title: AppLocalizations.of(context)!.anxiety,
                    questions: AnxietyQuestions.getQuestions(context),
                    colors: [MyTheme.primaryLight, MyTheme.backgroundButtonColor],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 60),
                  AssessmentTile(
                    title: AppLocalizations.of(context)!.ptsd,
                    questions: PTSDQuestions.getQuestions(context),
                    colors: [MyTheme.primaryLight, MyTheme.backgroundButtonColor],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 60),
                  AssessmentTile(
                    title: AppLocalizations.of(context)!.schizophrenia,
                    questions: SchizophreniaQuestions.getQuestions(context),
                    colors: [MyTheme.primaryLight, MyTheme.backgroundButtonColor],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 60),
                  AssessmentTile(
                    title: AppLocalizations.of(context)!.addiction,
                    questions: AddictionQuestions.getQuestions(context),
                    colors: [MyTheme.primaryLight, MyTheme.backgroundButtonColor],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 60),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 5.w,
          ),
          Text(
            textAlign: TextAlign.center,
            AppLocalizations.of(context)!.assessment_test,
            style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: MyTheme.primaryLight
            ),
          ),
        ],
      ),
    );
  }
}
