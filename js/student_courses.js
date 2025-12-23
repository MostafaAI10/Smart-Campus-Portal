const courseList = document.getElementById("courses-list");
const dialogs = document.querySelectorAll("dialog");
const semesterSeason = document.getElementById("semester-season");
const studentId = sessionStorage.getItem("id");

const currentMonth = new Date().getMonth();
const currentYear = new Date().getFullYear();

let season;
if (currentMonth >= 2 && currentMonth <= 4) {
    season = "Spring";
} else if (currentMonth >= 5 && currentMonth <= 7) {
    season = "Summer";
} else if (currentMonth >= 8 && currentMonth <= 10) {
    season = "Fall";
} else {
    season = "Winter";
}

semesterSeason.innerHTML = `${season} Semester ${currentYear}`;
semesterSeason.textContent = `${season} Semester, ${currentYear}`;

async function getUserCourses() {
    try {
        const response = await fetch("../backend/get_student_courses.php", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({ studentId })
        });
        
        if (!response.ok) {
            throw new Error("Failed to fetch courses");
        }
        
        return await response.json();
    } catch (error) {
        console.error("Error fetching student courses:", error);
        return [];
    }
}


getUserCourses().then((courses) => {
    courses.forEach((course) => {
        console.log("Processing course:", course);  
        const courseCard = document.createElement("div");
        const courseStatus = (course["course_grade"] > 85) ? "good" : (course["course_grade"] >= 60 ? "mediocre" : "bad");
        const instructorId = course["instructor_id"];
        courseCard.className = "course-card";
        courseCard.id = `course-${course["code"]}-card`;

        courseCard.innerHTML = `
                <div class="card-top-style ${courseStatus}"></div>
                <span>
                    <p class="small">${course["code"]}</p>
                    <h2>${course["name"]}</h2>
                </span>
                <div id="course-${course["code"]}-instructor-${instructorId}" class="instructor-info">
                    <img src="../assets/images/${course["instructor_picture"]}" alt="Instructor Photo" />
                    <p>${course["instructor_name"]}</p>
                </div>
                <div id="course-${course["code"]}-grade" class="course-grade">
                    <p>Current Grade <span class="${courseStatus}">${course["course_grade"]}%</span></p>
                    <div class="progress-bar">
                        <div class="progress ${courseStatus}" id="course-${course["code"]}-progress" style="width: ${course["course_grade"]}%;"></div>
                    </div>
                </div>
            `
        courseList.appendChild(courseCard);

        const courseDialog = document.createElement("dialog");
        courseDialog.className = "course-dialog";
        courseDialog.id = `course-${course["code"]}-dialog`;
        courseDialog.innerHTML = `
                <div class="dialog-header">
                    <h3>${course["name"]} <span class="small">${course["code"]}</span></h3>
                    <button class="close-btn">&times;</button>
                </div>
                <div class="dialog-body">
                    <p><strong>Instructor:</strong> ${course["instructor_name"]}</p>
                    <p><strong>Credits:</strong> ${course["credits"]}</p>
                    <p><strong>Description:</strong> ${course["description"]}</p>
                    <table id="student-${studentId}-${course["code"]}-grades" class="grades-table">
                        <thead>
                            <tr>
                                <th>Assessment</th>
                                <th>Date</th>
                                <th>Grade (%)</th>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td colspan="2"><strong>Total Grade</strong></td>
                                <td><strong>${course["course_grade"]}%</strong></td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            `;
          course["assessments"].forEach((assessment) => {
                const tr = document.createElement("tr");
                tr.innerHTML = `
                    <td>${assessment["name"]}</td>
                    <td>${assessment["due_date"]}</td>
                    <td>${assessment["score"] ?? "TBD"}</td>
                `;
                courseDialog.querySelector("tbody").appendChild(tr);
          });
        document.body.appendChild(courseDialog);

        const instructorDialog = document.createElement("dialog");
        instructorDialog.id = `instructor-${instructorId}-dialog`;
        instructorDialog.className = "course-dialog instructor-dialog";
        instructorDialog.innerHTML = `
            <div class="dialog-header">
                <h3>${course["instructor_name"]}</h3>
                <button class="close-btn">&times;</button>
            </div>
            <div class="dialog-body">
                <div class="instructor-detail">
                    <img src="../assets/images/${course["instructor_picture"]}" alt="Instructor Image">
                    <div>
                        <p><strong>Full Name:</strong> ${course["instructor_name"]}</p>
                        <p><strong>Email:</strong> ${course["instructor_email"]}</p>
                    </div>
                </div>
            </div>
        `;

        document.body.appendChild(instructorDialog);
    });

    const courseDialogs = document.querySelectorAll(".course-dialog");
    courseDialogs.forEach((dialog) => {
    const closeButton = dialog.querySelector("button");
    closeButton.addEventListener("click", () => {
        console.log("Closing dialog:", dialog.id);
        dialog.close();
        });
    }); 

    const instructorDialogs = document.querySelectorAll(".instructor-dialog");
    instructorDialogs.forEach((dialog) => {
    const closeButton = dialog.querySelector(".close-btn");
    closeButton.addEventListener("click", () => {
        dialog.close();
        });
    });
}).catch((error) => {
    console.error("Error processing courses:", error);
});



courseList.addEventListener("click", (event) => {
    const instructorInfo = event.target.closest(".instructor-info");
    const courseCard = event.target.closest(".course-card");

    if (instructorInfo) {
        event.stopPropagation();
        console.log("Instructor info clicked");
        const instructorId = instructorInfo.id.split("-")[3];
        const instructorDialog = document.getElementById(`instructor-${instructorId}-dialog`);
        if (instructorDialog) {
            console.log("found dialog for instructor ID:", instructorId);
            instructorDialog.showModal();
        }
        return;
    } 
    
    if (courseCard) {
        console.log("Course card clicked");
        const courseId = courseCard.id.split("-")[1];
        console.log("course ID:", courseId);
        const courseDialog = document.getElementById(`course-${courseId}-dialog`);
        if (courseDialog) {
            console.log("found dialog for course ID:", courseId);
            courseDialog.showModal();
        }
    }
});
