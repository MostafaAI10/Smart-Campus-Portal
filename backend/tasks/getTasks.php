<?php
header("Content-Type: application/json");
include "../db.php";

$json = file_get_contents("php://input");
$data = json_decode($json, true);

$userId = $data["userId"] ?? null;

if (!$userId) {
    http_response_code(400);
    echo json_encode(["error" => "User ID is required"]);
    exit();
}

$sql = "SELECT 
    id,
    title,
    description AS category,
    DATE_FORMAT(due_date, '%Y-%m-%d') AS dueDate,
    priority,
    is_completed AS completed
FROM tasks 
WHERE user_id = ?
ORDER BY due_date ASC, priority DESC";

$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $userId);
$stmt->execute();
$result = $stmt->get_result();

$tasks = [];
while ($row = $result->fetch_assoc()) {
    $row['completed'] = (bool)$row['completed'];
    $row['type'] = 'task'; // Default type since it's not in DB
    $tasks[] = $row;
}

$stmt->close();
$conn->close();

echo json_encode($tasks);
