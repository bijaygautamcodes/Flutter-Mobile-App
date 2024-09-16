import 'package:objectbox/objectbox.dart';
import 'package:rootnode/model/user/user.dart';

@Entity()
class Connection {
  Connection({this.id, this.rootnode, this.node, this.createdAt, this.cid = 0});

  @Id(assignable: true)
  int cid;
  @Unique()
  String? id;
  String? rootnode;
  User? node;
  @Property(type: PropertyType.date)
  DateTime? createdAt;

  factory Connection.fromJson(Map<String, dynamic> json) => Connection(
        id: json["_id"],
        rootnode: json["rootnode"],
        node: json["node"] == null ? null : User.fromJson(json["node"]),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
      );
}
