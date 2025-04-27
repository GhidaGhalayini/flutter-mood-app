// Class representing a mood type, containing its name and associated image
class MoodType {
  String? image;  // Image path or asset for the mood
  String? name;   // Name of the mood (e.g., "happy", "sad")

  // Constructor to initialize the mood with optional name and image parameters
  MoodType({this.name, this.image});
}
