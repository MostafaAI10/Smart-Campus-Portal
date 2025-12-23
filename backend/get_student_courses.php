<?php
header("Content-Type: application/json");
include "db.php";

$json = file_get_contents("php://input");
$data = json_decode($json, true);

$studentId = $data["studentId"] ?? $data["userId"] ?? $data["id"] ?? null;

if (!$studentId) {
    http_response_code(400);
    echo json_encode(["error" => "Student ID is null"]);
    exit();
}

// Get courses with average grade
$sql = "SELECT 
    c.id AS course_id,
    c.code,
    c.name,
    c.description,
    c.credits,
    CONCAT(u.first_name, ' ', u.last_name) AS instructor_name,
    u.profile_picture AS instructor_picture,
    u.id AS instructor_id,
    u.email AS instructor_email,
    ROUND(AVG(g.score), 2) AS course_grade
    FROM enrollments e
    JOIN courses c ON e.course_id = c.id
    JOIN semesters s ON c.semester_id = s.id
    LEFT JOIN users u ON c.instructor_id = u.id
    LEFT JOIN assessments a ON a.course_id = c.id
    LEFT JOIN grades g ON g.assessment_id = a.id AND g.student_id = e.student_id
    WHERE e.student_id = ? AND s.is_current = TRUE
    GROUP BY c.id, c.code, c.name, c.description, c.credits, 
         instructor_name, u.profile_picture, u.id";

$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $studentId);
$stmt->execute();
$result = $stmt->get_result();

$courses = [];
while ($row = $result->fetch_assoc()) {
    $row['assessments'] = [];
    $courses[$row['course_id']] = $row;
}
$stmt->close();

// Get assessments with grades for each course
$sqlAssessments = "SELECT 
    a.id AS assessment_id,
    a.course_id,
    a.name,
    a.type,
    a.max_score,
    a.due_date,
    g.score
FROM assessments a
JOIN courses c ON a.course_id = c.id
JOIN enrollments e ON e.course_id = c.id
JOIN semesters s ON c.semester_id = s.id
LEFT JOIN grades g ON g.assessment_id = a.id AND g.student_id = e.student_id
WHERE e.student_id = ? AND s.is_current = TRUE
ORDER BY a.due_date";

$stmt2 = $conn->prepare($sqlAssessments);
$stmt2->bind_param("i", $studentId);
$stmt2->execute();
$result2 = $stmt2->get_result();

while ($row = $result2->fetch_assoc()) {
    $courseId = $row['course_id'];
    unset($row['course_id']);
    if (isset($courses[$courseId])) {
        $courses[$courseId]['assessments'][] = $row;
    }
}
$stmt2->close();

http_response_code(200);
echo json_encode(array_values($courses));

$conn->close();

