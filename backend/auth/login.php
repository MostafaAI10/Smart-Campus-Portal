<?php 
include "../db.php";


$json = file_get_contents("php://input");
$json = json_decode($json, true);

$email = $json["email"];
$password = $json["password"];

$stmt = $conn->prepare("SELECT * FROM users WHERE email = ?");
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 0) {
    http_response_code(401);
    echo json_encode(["error" => "Invalid email or password (not found in db)"]);
    exit();
}

$user = $result->fetch_assoc();

if (!password_verify($password, $user["password_hash"])) {
    http_response_code(401);
    echo json_encode(["error" => "Invalid email or password"]);
    exit();
}

http_response_code(200);
echo json_encode($user);