<?php
header("Content-Type: application/json");
include "../db.php";

$json = file_get_contents("php://input");
$data = json_decode($json, true);

$id = $data["id"] ?? null;
$title = $data["title"] ?? null;
$category = $data["category"] ?? null;
$dueDate = $data["dueDate"] ?? null;
$priority = $data["priority"] ?? null;
$completed = isset($data["completed"]) ? $data["completed"] : null;

if (!$id) {
    http_response_code(400);
    echo json_encode(["error" => "Task ID is required"]);
    exit();
}

// Build dynamic update query based on provided fields
$updates = [];
$params = [];
$types = "";

if ($title !== null) {
    $updates[] = "title = ?";
    $params[] = $title;
    $types .= "s";
}

if ($category !== null) {
    $updates[] = "description = ?";
    $params[] = $category;
    $types .= "s";
}

if ($dueDate !== null) {
    $updates[] = "due_date = ?";
    $params[] = $dueDate;
    $types .= "s";
}

if ($priority !== null) {
    $validPriorities = ['low', 'medium', 'high'];
    if (in_array($priority, $validPriorities)) {
        $updates[] = "priority = ?";
        $params[] = $priority;
        $types .= "s";
    }
}

if ($completed !== null) {
    $updates[] = "is_completed = ?";
    $params[] = $completed ? 1 : 0;
    $types .= "i";
}

if (empty($updates)) {
    http_response_code(400);
    echo json_encode(["error" => "No fields to update"]);
    exit();
}

$sql = "UPDATE tasks SET " . implode(", ", $updates) . " WHERE id = ?";
$params[] = $id;
$types .= "i";

$stmt = $conn->prepare($sql);
$stmt->bind_param($types, ...$params);

if ($stmt->execute()) {
    echo json_encode([
        "success" => true,
        "message" => "Task updated successfully"
    ]);
} else {
    http_response_code(500);
    echo json_encode(["error" => "Failed to update task"]);
}

$stmt->close();
$conn->close();
