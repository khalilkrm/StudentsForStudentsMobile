class Event {
  final String? uid;
  final String? description;
  final DateTime? endDate;
  final DateTime? startDate;
  final String? location;
  final String? summary;

  Event(
      {this.uid,
        this.description,
        this.endDate,
        this.startDate,
        this.location,
        this.summary});
}