import 'package:hive/hive.dart';
// import 'package:json_annotation/json_annotation.dart';
part 'item.g.dart';

// @JsonSerializable()
// class Item {
//   final int id;
//   final String? title;
//   final String? description;

//   Item(this.id, this.title, this.description);

//   /// A necessary factory constructor for creating a new User instance
//   /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
//   /// The constructor is named after the source class, in this case, User.
//   factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

//   /// `toJson` is the convention for a class to declare support for serialization
//   /// to JSON. The implementation simply calls the private, generated
//   /// helper method `_$UserToJson`.
//   Map<String, dynamic> toJson() => _$ItemToJson(this);
// }

@HiveType(typeId: 0, adapterName: "ItemAdapter")
class Item extends HiveObject {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? title;
  @HiveField(2)
  String? body;
  Item({
    this.id,
    this.title,
    this.body,
  });
  Item.fromJson(Map<String, dynamic> json) {
    // print('fromjson:$json');
    // ignore: unnecessary_null_comparison
    if (json != null) {
      id = json['id'];
      title = json['title'];
      body = json['body'];
    } else {
      print('in else profile from json');
      // name = '';
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;

    return data;
  }
}
