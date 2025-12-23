<?php
header("Content-Type: application/json");

include "db.php";

$sql = "SELECT * FROM announcements ORDER BY created_at DESC";

$stmt = $conn->prepare($sql);
$stmt->execute();
$result = $stmt->get_result();

$announcements = [];
while ($row = $result->fetch_assoc()) {
    $announcements[] = $row;
}

$stmt->close();
$conn->close();

echo json_encode($announcements);
