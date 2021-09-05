import 'package:get/get.dart';

/// This class handles all translation logic of the application.
///
/// @author Felix Mayer
/// @author Turan Ledermann

abstract class AppTranslations extends Translations {
  // maps the vocabulary to the corresponding language.
  static Map<String, Map<String, String>> translationsKeys = {
    "en": en,
    "de": de
  };
}

final Map<String, String> en = {
  'IndicatorYourProgress': 'Your Progress',
  'IndicatorLow': 'low',
  'IndicatorMedium': 'medium',
  'IndicatorGood': 'good',
  'IndicatorExcellent': 'excellent',
//
  'HomeContinueLesson': 'Continue Lesson',
  'HomeSelectLesson': 'Select Lesson',
  'HomeMyComments': 'My Comments',
  'HomeProfile': 'Profile',
  'HomeSettings': 'Settings',
//
  'LessonTopicSelection': 'Topic Selection',
//
  'LessonSelectionMotivation': 'Motivation',
  'LessonSelectionLength': 'Length',
  'LessonSelectionDifficulty': 'Difficulty',
  'Difficulty.beginner': 'Beginner',
  'Difficulty.advanced': 'Advanced',
  'Difficulty.master': 'Master',
  'LessonSelectionStart': 'Start',
//
  'LessonCompleteComplete': 'Complete!',
  'LessonCompleteCongratulations': 'Congratulations!',
  'LessonCompleteLearnScore': 'Learn-Score',
  'LessonCompleteText1':
      'If you now and in the future follow all the recommendations given in this tutorial your cyber security will be much improved.',
  'LessonCompleteText2':
      'It is recommended that you revisit this lesson in the future to keep practising.',
  'LessonCompleteRemindMe': 'Remind me:',
  'LessonCompleteSetReminder': 'Set Reminder',
  'LessonCompleteFinishLesson': 'Done!',
  'LessonCompleteQuiz': 'Quiz-Results',
//
  'QuizFinishQuiz': 'Done!',
//
  'MyCommentsTitle': 'My Comments',
  'MyCommentsDismissed': ' deleted',
  'MyCommentsTopic': 'Topic: ',
  'MyCommentsNoComments':
      'Your comments written in the different lessons will appear here. \n \nSo far you have either not written any or dismissed them all.',
  'MyCommentsDismissInstruction':
      'To dismiss comments drag them to the all the way to the left.',
//
  'ProfileTitle': 'Profile',
  'ProfileChangeAvatar': 'Change Image',
  'ProfileUserName': 'Username',
  'ProfileLearnScore': 'Learn-Score',
  'ProfileText1':
      "The learn-score helps you track your own as well as other people's overall progress and knowledge in the discussion platform. Share your score with your co-workers to see who is the furthest.\n\nImprove your score by finishing lessons.",
  'ProfileExportLearningProgress': 'Export Learning Progress',
//
  'SettingsTitle': 'Settings',
  'SettingsDarkMode': 'Dark Mode',
  'SettingsLessons': 'Lessons',
  'SettingsSetDisplayAnonymous':
      'Display your name as Anonymous on discussion platform',
  'SettingsSetDisplayScore': 'Display your learn-score on discussion platform',
//
  'ChatTitle': 'Discussion: ',
  'ChatNoInternetConnection':
      'NO INTERNET CONNECTION AVAILABLE\n\nMake sure you have a stable connection to the internet in order to be able to use the GEIGER Mobile discussion platform.',
  'ChatDeleteMessage': 'Delete Message?',
  'ChatDeleteMessagePopup':
      'By deleting your message you will delete it for everybody.\n\nAre you sure you want to do this?',
  'ChatDeleteMessageNo': 'NO',
  'ChatDeleteMessageYes': 'YES',
  'ChatWriteMessage': 'Write a message...'
};

final Map<String, String> de = {
  'IndicatorYourProgress': 'Dein Fortschritt',
  'IndicatorLow': 'tief',
  'IndicatorMedium': 'mittel',
  'IndicatorGood': 'gut',
  'IndicatorExcellent': 'super',
//
  'HomeContinueLesson': 'Lektion fortsetzen',
  'HomeSelectLesson': 'Lektion auswählen',
  'HomeMyComments': 'Meine Kommentare',
  'HomeProfile': 'Profil',
  'HomeSettings': 'Einstellungen',
//
  'LessonTopicSelection': 'Thema auswählen',
//
  'LessonSelectionMotivation': 'Motivation',
  'LessonSelectionLength': 'Länge',
  'LessonSelectionDifficulty': 'Schwierigkeitsgrad',
  'Difficulty.beginner': 'Anfänger',
  'Difficulty.advanced': 'Fortgeschritten',
  'Difficulty.master': 'Meister',
  'LessonSelectionStart': 'Start',
//
  'LessonCompleteComplete': 'Fertig!',
  'LessonCompleteCongratulations': 'Gratulation!',
  'LessonCompleteLearnScore': 'Lern-Score',
  'LessonCompleteText1':
      'Wenn du ab jetzt den Empfehlungen aus diesem Tutorial folgst, wird deine Cybersicherheit sehr verbessert.',
  'LessonCompleteText2':
      'Es ist empfohlen, dass du diese Lektion in der Zukunft wiederholst, um weiterzuüben',
  'LessonCompleteRemindMe': 'Erinnere mich:',
  'LessonCompleteSetReminder': 'Setze Erinnerungsdatum',
  'LessonCompleteFinishLesson': 'Fertig!',
  'LessonCompleteQuiz': 'Quiz Resultate:',
//
  'QuizFinishQuiz': 'Fertig!',
//
  'MyCommentsTitle': 'Meine Kommentare',
  'MyCommentsDismissed': ' gelöscht',
  'MyCommentsTopic': 'Thema: ',
  'MyCommentsNoComments':
      'Deine Kommentare aus den Lektionen werden hier erscheinen. \n \nMomentan hast du keine Kommentare.',
  'MyCommentsDismissInstruction':
      'Um einen Kommentar zu löschen, ziehe ihn nach links.',
//
  'ProfileTitle': 'Profil',
  'ProfileChangeAvatar': 'Bild ändern',
  'ProfileUserName': 'Benutzername',
  'ProfileLearnScore': 'Lern-Score',
  'ProfileText1':
      "Der Lern-Score hilft dir, das Wissen und den Fortschritt von dir und anderen zu verfolgen. Teile deinen Score mit anderen um zu sehen, wer am weitesten ist.\n\nVerbessere deinen Score indem du Lektionen abschliesst.",
  'ProfileExportLearningProgress': 'Lernfortschritt exportieren',
//
  'SettingsTitle': 'Einstellungen',
  'SettingsDarkMode': 'Dunkelmodus',
  'SettingsLessons': 'Lektionen',
  'SettingsSetDisplayAnonymous': 'Als Anonym auf Diskussionsplattform anzeigen',
  'SettingsSetDisplayScore': 'Lern-Score auf Diskussionsplattform anzeigen',
//
  'ChatTitle': 'Diskussion: ',
  'ChatNoInternetConnection':
      'KEINE INTERNETVERBINDUNG\n\nStelle sicher, dass du eine stabile Verbindung zum Internet hast, um die GEIGER Mobile Learning-Diskussionsplattform nutzen zu können.',
  'ChatDeleteMessage': 'Nachricht löschen?',
  'ChatDeleteMessagePopup':
      'Wenn du deine Nachricht löschst, ist sie für alle gelöscht.\n\nBist du sicher, dass du diese Nachricht löschen willst?',
  'ChatDeleteMessageNo': 'NEIN',
  'ChatDeleteMessageYes': 'JA',
  'ChatWriteMessage': 'Schreibe eine Nachricht...'
};
