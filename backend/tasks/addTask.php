<?php
header("Content-Type: application/json");
include "../db.php";

$json = file_get_contents("php://input");
$data = json_decode($json, true);

$userId = $data["userId"] ?? null;
$title = $data["title"] ?? null;
$category = $data["category"] ?? null;
$dueDate = $data["dueDate"] ?? null;
$priority = $data["priority"] ?? 'medium';

if (!$userId || !$title) {
    http_response_code(400);
    echo json_encode(["error" => "User ID and title are required"]);
    exit();
}

// Validate priority
$validPriorities = ['low', 'medium', 'high'];
if (!in_array($priority, $validPriorities)) {
    $priority = 'medium';
}

$sql = "INSERT INTO tasks (user_id, title, description, due_date, priority, is_completed) 
        VALUES (?, ?, ?, ?, ?, FALSE)";

$stmt = $conn->prepare($sql);
$stmt->bind_param("issss", $userId, $title, $category, $dueDate, $priority);

if ($stmt->execute()) {
    $newId = $conn->insert_id;
    echo json_encode([
        "success" => true,
        "id" => $newId,
        "message" => "Task added successfully"
    ]);
} else {
    http_response_code(500);
    echo json_encode(["error" => "Failed to add task"]);
}

$stmt->close();
$conn->close();
