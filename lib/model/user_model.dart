class UserModel{
  String name;
  String phoneNumber;
  String image;
  int age;
  bool delete;
  DateTime date;
  List search;

  UserModel({
    required this.name,
    required this.phoneNumber,
    required this.image,
    required this.age,
    required this.delete,
    required this.search,
    required this.date,
  });
  UserModel copyWith({
    String? name,
    String? phoneNumber,
    String? image,
    int? age,
    bool? delete,
    DateTime? date,
    List? search,
  })=>
      UserModel
        (name: name?? this.name,
        phoneNumber: phoneNumber?? this.phoneNumber,
        image: image?? this.image,
        age: age?? this.age,
        delete: delete?? this.delete,
        search: search?? this.search,
        date: date?? this.date,
      );
  factory UserModel.fromJson(dynamic json)=>UserModel(
    name: json["name"],
    phoneNumber: json["phoneNumber"],
    image: json["image"],
    age: json["age"]??0,
    delete: json["delete"],
    date: json["date"].toDate(),
    search: json["search"],
  );
  Map<String,dynamic> toJson()=>{
    "name":name,
    "phoneNumber":phoneNumber,
    "image":image,
    "age":age,
    "delete":delete,
    "date":date,
    "search":search,
  };
}