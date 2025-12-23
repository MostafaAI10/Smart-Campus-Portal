<?php
header("Content-Type: application/json");

include "db.php";

$raw = file_get_contents("php://input");
$data = json_decode($raw, true);

$studentId = $data["userId"] ?? $data["studentId"] ?? null;

if (!$studentId) {
    http_response_code(400);
    echo json_encode(["error" => "studentId (or userId) is required"]);
    exit();
}

// Fetch the student's schedule based on enrolled courses.
$sql = "
SELECT
    c.id AS course_id,
    c.code AS course_code,
    c.name AS course_name,
    cs.day_of_week,
    cs.start_time,
    cs.end_time,
    cs.room
FROM enrollments e
JOIN courses c ON c.id = e.course_id
JOIN course_schedules cs ON cs.course_id = c.id
WHERE e.student_id = ?
ORDER BY
    FIELD(cs.day_of_week, 'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'),
    cs.start_time,
    c.code
";

$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $studentId);
$stmt->execute();
$result = $stmt->get_result();

$schedule = [];
while ($row = $result->fetch_assoc()) {
    $schedule[] = $row;
}

$stmt->close();
$conn->close();

echo json_encode($schedule);
