/// A sitting left open in the background must not count as hours of study.
const maxStudySessionDuration = Duration(minutes: 60);

Duration cappedStudyDuration(Duration d) =>
    d > maxStudySessionDuration ? maxStudySessionDuration : d;
