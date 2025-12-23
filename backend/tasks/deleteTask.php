<?php
header("Content-Type: application/json");
include "../db.php";

$json = file_get_contents("php://input");
$data = json_decode($json, true);

$id = $data["id"] ?? null;

if (!$id) {
    http_response_code(400);
    echo json_encode(["error" => "Task ID is required"]);
    exit();
}

$sql = "DELETE FROM tasks WHERE id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $id);

if ($stmt->execute()) {
    if ($stmt->affected_rows > 0) {
        echo json_encode([
            "success" => true,
            "message" => "Task deleted successfully"
        ]);
    } else {
        http_response_code(404);
        echo json_encode(["error" => "Task not found"]);
    }
} else {
    http_response_code(500);
    echo json_encode(["error" => "Failed to delete task"]);
}

$stmt->close();
$conn->close();
