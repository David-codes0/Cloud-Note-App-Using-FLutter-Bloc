// ignore_for_file: public_member_api_docs, sort_constructors_first
class OnBoarding {
  String title;
  String content;
  String image;
  OnBoarding({
    required this.title,
    required this.content,
    required this.image,
  });
}

List<OnBoarding> onBoardingContent = [
  OnBoarding(
    title: 'When Your Heart Speak\nTake Note',
    content:
        '"The more content you try to capture during a lecture or a meeting, the less you\'re thinking about what\'s being said. So take note "',
    image: 'assets/images/mynoteapp-img1.jpg',
  ),
  OnBoarding(
    title: 'Take notes\neverything is copy',
    content:
        '"The more content you try to capture during a lecture or a meeting, the less you\'re thinking about what\'s being said. So take note "',
    image: 'assets/images/mynoteapp-img2.jpg',
  ),
  OnBoarding(
    title: 'Create notes and\nnever loss those inspirations',
    content:
        '"The more content you try to capture during a lecture or a meeting, the less you\'re thinking about what\'s being said. So take note "',
    image: 'assets/images/mynoteapp-img3.jpg',
  ),
  OnBoarding(
    title: 'Write it\ndown now !',
    content:
        '"The more content you try to capture during a lecture or a meeting, the less you\'re thinking about what\'s being said. So take note "',
    image: 'assets/images/mynoteapp-img4.jpg',
  )
];
