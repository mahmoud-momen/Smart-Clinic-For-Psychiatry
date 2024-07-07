class PageContent {
  static String getPageContent(int pageNumber) {
    switch (pageNumber) {
      case 1:
        return '''The Smart Clinic App is a mobile application developed to offer mental health care and support for patients and psychiatrists. This app allows users to log in as either a patient or a doctor and access various features, chat bot AI, chat between doctor and patient, PTSD, schizophrenia, addiction and anxiety and mental health articles. The app is built using Flutter, a cross-platform framework for native app development, and Firebase, a cloud-based backend platform. Additionally, the app integrates various APIs and libraries for stress measurement. The primary goal of the app is to enhance the quality of mental health care and improve communication between patients and doctors.
''';
      case 2:
        return '''          ACKNOWLEDGMENT
        
We express our gratitude to the individuals and organizations that have contributed to the development of this app. We would like to thank our supervisor, Professor Dr Ahmed Mostafa El Mahalawy and dean of the college, Dr. Rania Al Gohary, for their guidance and support throughout this project. We would also like to thank our classmates and friends for their valuable feedback and suggestions. We are grateful to the Flutter community for providing us with various resources and tools to learn and develop our app. We appreciate the Firebase team for offering us free access to their platform and services. We acknowledge Google Cloud for providing us with additional features and functionalities that enhanced our app. Finally, we thank all the users who participated in our user research and user testing for their time and cooperation.
''';

      case 3:
        return '''               Meet Our Team
        
             Ahmed Mohamed
             Mohamed Hassan
             Ali Osman
             Mahmoud Mohamed
             Mohamed Abbas
             
             
             
             
             
             
            
            
            Under supervision 
           Associate Professor: 
     Ahmed Mostafa AlMahlawy

''';

      default:
        return '';
    }
  }
}
