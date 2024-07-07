import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DepressionQuestions {
  static List<String> getQuestions(BuildContext context) {
    return [
      AppLocalizations.of(context)!.are_you_having_thoughts_that_you_would_be_better_off_dead_or_of_hurting_yourself,
      AppLocalizations.of(context)!.are_you_having_trouble_concentrating_on_things_such_as_reading_the_newspaper_or_watching_tv,
      AppLocalizations.of(context)!.are_you_feeling_bad_about_yourself_ex_feel_like_a_failure_or_constantly_let_your_family_down,
      AppLocalizations.of(context)!.do_you_have_a_poor_appetite_or_are_you_overeating,
      AppLocalizations.of(context)!.are_you_feeling_tired_or_having_little_energy,
      AppLocalizations.of(context)!.are_you_having_trouble_falling_or_staying_asleep_or_sleeping_too_much,
      AppLocalizations.of(context)!.are_you_feeling_down_depressed_or_hopeless,
      AppLocalizations.of(context)!.do_you_have_little_interest_or_pleasure_in_doing_things,
    ];
  }
}

class AnxietyQuestions {
  static List<String> getQuestions(BuildContext context) {
    return [
      AppLocalizations.of(context)!.are_you_feeling_nervous_anxious_or_on_edge,
      AppLocalizations.of(context)!.are_you_feeling_unable_to_stop_or_control_worrying,
      AppLocalizations.of(context)!.are_you_worrying_too_much_about_different_things,
      AppLocalizations.of(context)!.are_you_having_trouble_relaxing,
      AppLocalizations.of(context)!.are_you_so_restless_that_it_is_hard_to_sit_still,
      AppLocalizations.of(context)!.are_you_feeling_easily_annoyed_or_irritable,
      AppLocalizations.of(context)!.are_you_feeling_as_if_something_awful_might_happen,
    ];
  }
}

class PTSDQuestions {
  static List<String> getQuestions(BuildContext context) {
    return [
      AppLocalizations.of(context)!.are_you_having_nightmares_about_a_distressing_events_or_thought_about_the_events_when_you_did_not_want_to,
      AppLocalizations.of(context)!.are_you_trying_hard_not_to_think_about_a_distressing_events_or_went_out_of_your_way_to_avoid_situations_that_reminded_you_of_the_events,
      AppLocalizations.of(context)!.do_you_feel_constantly_on_guard_watchful_or_easily_startled,
      AppLocalizations.of(context)!.do_you_feel_numb_or_detached_from_people_activities_or_your_surroundings,
      AppLocalizations.of(context)!.do_you_feel_guilty_or_unable_to_stop_blaming_yourself_or_others_for_a_distressing_events_or_any_problems_the_events_may_have_caused,
    ];
  }
}

class SchizophreniaQuestions {
  static List<String> getQuestions(BuildContext context) {
    return [
      AppLocalizations.of(context)!.are_you_experiencing_any_brain_fog,
      AppLocalizations.of(context)!.are_you_struggling_to_remember_to_eat_or_drink_water,
      AppLocalizations.of(context)!.are_your_thoughts_jumbled_or_are_you_unable_to_think_clearly,
      AppLocalizations.of(context)!.are_you_having_trouble_seeing_things_or_are_you_seeing_things_that_arent_there,
      AppLocalizations.of(context)!.do_you_feel_extremely_tired,
      AppLocalizations.of(context)!.are_the_happy_thoughts_speeding_up_your_thought_process,
      AppLocalizations.of(context)!.are_the_sad_thoughts_slowing_down_your_thought_process,
      AppLocalizations.of(context)!.are_you_having_any_grandiose_thoughts,
    ];
  }
}

class AddictionQuestions {
  static List<String> getQuestions(BuildContext context) {
    return [
      AppLocalizations.of(context)!.are_you_using_substances_to_numb_any_physical_or_emotional_pain,
      AppLocalizations.of(context)!.do_you_feel_like_you_should_cut_down_on_your_substance_use,
      AppLocalizations.of(context)!.are_you_feeling_guilty_about_using_substances,
      AppLocalizations.of(context)!.is_anyone_annoying_you_by_criticizing_your_substance_use,
      AppLocalizations.of(context)!.do_you_feel_that_your_substance_use_significantly_decreases_your_ability_to_function,
      AppLocalizations.of(context)!.are_you_using_substances_as_soon_as_you_wake_up_in_the_morning
    ];
  }
}

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: DepressionQuestions.getQuestions(context).length,
        itemBuilder: (context, index) {
          return Text(
            DepressionQuestions.getQuestions(context)[index],
            style: TextStyle(fontSize: 15, color: Colors.black),
          );
        },
      ),
    );
  }
}
