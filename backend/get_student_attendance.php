<?php
header("Content-Type: application/json");
include "db.php";

$json = file_get_contents("php://input");
$data = json_decode($json, true);

$studentId = $data["id"] ?? $data["userId"] ?? $data["studentId"] ?? null;

if (!$studentId) {
    http_response_code(400);
    echo json_encode(["error" => "Student ID is null"]);
    exit();
}

// Course Code, course name, total classes and attended classes
$sql = "SELECT 
    c.code AS course_code,
    c.name AS course_name,
    COUNT(a.id) AS total_classes,
    SUM(CASE WHEN a.status = 'present' THEN 1 ELSE 0 END) AS attended_classes
    FROM enrollments e
    JOIN courses c ON e.course_id = c.id
    JOIN semesters s ON c.semester_id = s.id
    LEFT JOIN attendance a ON a.course_id = c.id AND a.student_id = e.student_id
    WHERE e.student_id = ? AND s.is_current = TRUE
    GROUP BY c.id, c.code, c.name
    ORDER BY c.code";

$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $studentId);
$stmt->execute();
$result = $stmt->get_result();

$attendances = [];
while ($row = $result->fetch_assoc()) {
    $attendances[] = $row;
}

$stmt->close();


http_response_code(200);
echo json_encode($attendances);
$conn->close();