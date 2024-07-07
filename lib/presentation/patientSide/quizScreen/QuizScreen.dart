import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:smart_clinic_for_psychiatry/presentation/common/components/appTheme/my_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smart_clinic_for_psychiatry/provider/app_config_provider.dart';

class QuizScreen extends StatefulWidget {
  QuizScreen(this.question, this.x, this.disorder, this.colors);
  List<String> question;
  final String disorder;
  final int x;
  final List<Color> colors;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Scaffold(
      backgroundColor:
          provider.isDarkMode() ? MyTheme.primaryDark : MyTheme.whiteColor,
      body: Container(
        child:
            Question(widget.question, widget.x, widget.disorder, widget.colors),
      ),
    );
  }
}

class Question extends StatefulWidget {
  Question(this.question, this.qno, this.disorder, this.colors);
  final List<String> question;
  final int qno;
  final String disorder;
  final List<Color> colors;

  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  int i = 0;
  bool over = false;
  int ans = 0;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: height / 2.5,
              width: width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: widget.colors),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 75),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: MyTheme.whiteColor,
                        size: 40,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Padding(
                    child: Text(
                      over == false
                          ? AppLocalizations.of(context)!
                              .push_your_mental_boundaries
                          : AppLocalizations.of(context)!.results,
                      style: TextStyle(
                          color: MyTheme.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 90),
                  ),
                ],
              ),
            ),
            Positioned(
              top: height / 5.5,
              child: Container(
                height: height * 0.5,
                width: width / 1.2,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blueGrey, width: 2),
                  color: provider.isDarkMode()
                      ? MyTheme.primaryDark
                      : MyTheme.whiteColor,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        over == false
                            ? '${AppLocalizations.of(context)!.question_no} - ${i + 1}'
                            : AppLocalizations.of(context)!.conclusion,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: provider.isDarkMode()
                                ? MyTheme.whiteColor
                                : MyTheme.primaryDark),
                      ),
                      SizedBox(height: height / 30),
                      Text(
                        over == false
                            ? widget.question[i]
                            : ans == widget.qno
                                ? '${AppLocalizations.of(context)!.you_are_having_chances_of_suffering_through} ${widget.disorder}'
                                : ans >= widget.qno / 2
                                    ? '${AppLocalizations.of(context)!.you_have_moderate_chances_of_suffering_through} ${widget.disorder}'
                                    : '${AppLocalizations.of(context)!.you_have_very_low_chances_of_suffering_through} ${widget.disorder}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: provider.isDarkMode()
                                ? MyTheme.whiteColor
                                : MyTheme.primaryDark),
                      ),
                      SizedBox(height: 20),
                      over == true
                          ? Container(
                              child: CircularPercentIndicator(
                                radius: 80.0,
                                lineWidth: 13.0,
                                animation: true,
                                animationDuration: 600,
                                percent: ans == widget.qno
                                    ? 0.9
                                    : ans >= widget.qno / 2
                                        ? 0.6
                                        : 0.3,
                                center: new Text(
                                  ans == widget.qno
                                      ? AppLocalizations.of(context)!.high_risk
                                      : ans >= widget.qno / 2
                                          ? AppLocalizations.of(context)!
                                              .moderate_risk
                                          : AppLocalizations.of(context)!
                                              .low_risk,
                                  style: new TextStyle(
                                      color: provider.isDarkMode()
                                          ? MyTheme.whiteColor
                                          : MyTheme.primaryDark,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: ans == widget.qno
                                    ? Colors.red
                                    : ans >= widget.qno / 2
                                        ? Colors.orange
                                        : Colors.green,
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 0.35 * height),
        over == false
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 0.36 * width,
                    height: 0.08 * height,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          ans++;
                          i++;
                          if (i > widget.qno - 1) {
                            over = true;
                            String risk = ans == widget.qno
                                ? AppLocalizations.of(context)!.high
                                : ans >= widget.qno / 2
                                    ? AppLocalizations.of(context)!.moderate
                                    : AppLocalizations.of(context)!.low;
                          }
                        });
                      },
                      child: Text(
                        AppLocalizations.of(context)!.yes,
                        style: TextStyle(
                          color: provider.isDarkMode()
                              ? MyTheme.whiteColor
                              : MyTheme.primaryDark,
                          fontSize: 24,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            widget.colors[0].withOpacity(0.7)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 0.36 * width,
                    height: 0.08 * height,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          i++;
                          if (i > widget.qno - 1) {
                            over = true;
                          }
                        });
                      },
                      child: Text(
                        AppLocalizations.of(context)!.no,
                        style: TextStyle(
                          color: provider.isDarkMode()
                              ? MyTheme.whiteColor
                              : MyTheme.primaryDark,
                          fontSize: 24,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            widget.colors[1].withOpacity(0.8)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : ans == widget.qno
                ? Text(
                    AppLocalizations.of(context)!
                        .please_focus_on_yourself_and_give_your_self_some_time_to_meditate_and_relax,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: provider.isDarkMode()
                            ? MyTheme.whiteColor
                            : MyTheme.primaryDark),
                  )
                : ans >= widget.qno / 2
                    ? Text(
                        AppLocalizations.of(context)!
                            .keep_meditating_regularly_and_eat_healthy_you_are_just_few_days_away_from_perfect_mental_health,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: provider.isDarkMode()
                                ? MyTheme.whiteColor
                                : MyTheme.primaryDark),
                      )
                    : Text(
                        AppLocalizations.of(context)!
                            .your_health_seems_good_enough_Keep_it_up,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: provider.isDarkMode()
                                ? MyTheme.whiteColor
                                : MyTheme.primaryDark),
                      )
      ],
    );
  }
}
