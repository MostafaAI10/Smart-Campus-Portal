const form = document.getElementById("login-form");
const emailInput = document.getElementById("email");
const passwordInput = document.getElementById("password");
const loginButton = document.getElementById("login-btn");

const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

emailInput.addEventListener("input", () => {
    if (emailInput.value.trim() === "") {
        emailInput.setCustomValidity("Email cannot be empty");
        loginButton.disabled = true;
        emailInput.style.borderColor = "red";
    } else if (!emailRegex.test(emailInput.value.trim())) {
        emailInput.setCustomValidity("Invalid email format");
        loginButton.disabled = true;
        emailInput.style.borderColor = "red";
    } else {
        emailInput.setCustomValidity("");
        loginButton.disabled = false;
        emailInput.style.borderColor = "";
    }
});

form.addEventListener("submit", async (event) => {
    event.preventDefault();
    const email = emailInput.value;
    const password = passwordInput.value;
    try {
        const response = await fetch("backend/auth/login.php", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({ email, password })
        });
        if (!response.ok) {
            throw new Error("Login failed");
        }
        const data = await response.json();
        sessionStorage.setItem("id", data.id);
        sessionStorage.setItem("first_name", data.first_name);
        sessionStorage.setItem("last_name", data.last_name);
        sessionStorage.setItem("role", data.role);
        sessionStorage.setItem("card_balance", data.card_balance);
        sessionStorage.setItem("profile_picture", data.profile_picture);
        if (data["role"] === "student") {
            window.location.href = "student-webpage/student-dashboard.html";
        } else if (data["role"] === "staff") {
            window.location.href = "staff-webpage/staff-dashboard.html";
        }
        console.log(data);
    } catch (error) {
        alert(error.message);
    }
});