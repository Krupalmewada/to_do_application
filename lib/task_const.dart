
class Task{

  String text ="";
  bool checkbox=false;
  Task({required this.text,required this.checkbox});
  Map<String, dynamic> toMap() {
    return {
      text : checkbox,
    };
  }
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      text: map['text']??=[],
      checkbox: map['checkbox']??=[],
    );
  }
}