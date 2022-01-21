
import 'package:hive/hive.dart';
part 'hivemodel.g.dart';

@HiveType(typeId: 1,adapterName: "ServiceAdapter")
class GetService{
  @HiveField(0)
  String name;

  @HiveField(1)
  String lastname;

  @HiveField(2)
  String status;

  GetService({required this.name,required this.status,required this.lastname});
}