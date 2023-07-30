class ApplicationFile {
  final String filename;
  final String ownerName;
  final DateTime creationDate;
  final String ownerId;
  final int fileId;
  final String courseName;
  final int courseId;
  final String cursusName;
  final int cursusId;
  final String extension;

  ApplicationFile({
    required this.filename,
    required this.ownerName,
    required this.creationDate,
    required this.ownerId,
    required this.fileId,
    required this.courseName,
    required this.courseId,
    required this.cursusName,
    required this.cursusId,
    required this.extension,
  });

  static fromJson({required Map<String, dynamic> content}) {
    return ApplicationFile(
      filename: content['filename'],
      ownerName: content['ownerName'],
      extension: content['extension'],
      ownerId: content['ownerId'],
      fileId: content['fileId'],
      creationDate: DateTime.parse(content['creationDate']),
      courseName: content['course']['label'],
      courseId: content['course']['id'],
      cursusName: content['course']['cursus']['label'],
      cursusId: content['course']['cursus']['id'],
    );
  }
}
