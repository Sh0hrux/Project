import 'package:equatable/equatable.dart';

class Organization extends Equatable {
  final String id;
  final String name;

  const Organization({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
