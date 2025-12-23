const welcomingContainer = document.getElementById('welcoming-container');
const msg = welcomingContainer.querySelector("span > h1");
const announcementsList = document.getElementById("announcements-list");
const tasksList = document.getElementById("tasks-list");
let classesCount = document.getElementById("classes-count");
msg.textContent = `Welcome, ${sessionStorage.getItem("first_name")} ${sessionStorage.getItem("last_name")}!`;
let amountOfClasses;
const weekdays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

const gpa = document.getElementById("gpa-value");
const attendance = document.getElementById("attendance-percentage");
const cardBalance = document.getElementById("card-balance");
const assignmentCompconstion = document.getElementById("assignment-completion");

function calculateGpaFromCourses(studentCoursesData) {
    let totalCredits = 0;
    let weightedPointsSum = 0;

    for (const course of studentCoursesData) {
        const credits = Number(course?.credits ?? 0);
        const grade = course?.course_grade;

        if (!Number.isFinite(credits) || credits <= 0) continue;
        if (grade === null || grade === undefined || grade === "") continue;

        const percent = Number(grade);
        if (!Number.isFinite(percent)) continue;

        const gpaPoints = (Math.min(Math.max(percent, 0), 100) / 100) * 4;

        totalCredits += credits;
        weightedPointsSum += gpaPoints * credits;
    }

    if (totalCredits === 0) return null;
    return weightedPointsSum / totalCredits;
}

function calculateAssignmentCompletionPercent(studentCoursesData) {
    let total = 0;
    let completed = 0;

    for (const course of studentCoursesData) {
        for (const assessment of course?.assessments || []) {
            total += 1;
            const score = assessment?.score;
            if (score !== null && score !== undefined && score !== "") {
                completed += 1;
            }
        }
    }

    if (total === 0) return null;
    return Math.round((completed / total) * 100);
}

function calculateAttendancePercent(attendanceRows) {
    let totalClasses = 0;
    let attendedClasses = 0;

    for (const row of attendanceRows) {
        totalClasses += Number(row?.total_classes ?? 0);
        attendedClasses += Number(row?.attended_classes ?? 0);
    }

    if (!Number.isFinite(totalClasses) || totalClasses <= 0) return null;
    if (!Number.isFinite(attendedClasses) || attendedClasses < 0) return null;
    return Math.round((attendedClasses / totalClasses) * 100);
}

async function fetchRelevantObjects() {
    const userId = sessionStorage.getItem("id");
    const options = {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({ userId })
    };

    const attendanceOptions = {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({ id: userId, userId, studentId: userId })
    };

    const coursesOptions = {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({ studentId: userId, userId })
    };

    try {
        const [announcementsResponse, tasksResponse, scheduleResponse, studentCoursesResponse, attendanceResponse] = await Promise.all([
            fetch("../backend/get_announcements.php", options),
            fetch("../backend/tasks/getTasks.php", options),
            fetch("../backend/get_student_schedule.php", options),
            fetch("../backend/get_student_courses.php", coursesOptions),
            fetch("../backend/get_student_attendance.php", attendanceOptions)
        ]);

        if (!announcementsResponse.ok) {
            throw new Error("Failed to fetch announcements");
        }

        if (!tasksResponse.ok) {
            throw new Error("Failed to fetch tasks");
        }

        if (!scheduleResponse.ok) {
            throw new Error("Failed to fetch schedule");
        }

        if (!studentCoursesResponse.ok) {
            throw new Error("Failed to fetch student courses");
        }   

        if (!attendanceResponse.ok) {
            throw new Error("Failed to fetch student attendance");
        }

        const [announcementsData, tasksData, scheduleData, studentCoursesData, attendanceData] = await Promise.all([
            announcementsResponse.json(),
            tasksResponse.json(),
            scheduleResponse.json(),
            studentCoursesResponse.json(),
            attendanceResponse.json()
        ]);

        return {announcementsData, tasksData, scheduleData, studentCoursesData, attendanceData};
    } catch (error) {
        console.error("Error fetching data:", error);
        return {announcementsData: [], tasksData: [], scheduleData: [], studentCoursesData: [], attendanceData: []};
    }
}

fetchRelevantObjects().then(({announcementsData, tasksData, scheduleData, studentCoursesData, attendanceData}) => {
    console.log(announcementsData);
    console.log(tasksData);
    console.log(scheduleData);

    const computedGpa = calculateGpaFromCourses(studentCoursesData);
    gpa.textContent = computedGpa === null ? "-" : computedGpa.toFixed(2);

    const computedAttendance = calculateAttendancePercent(attendanceData);
    attendance.textContent = computedAttendance === null ? "-" : `${computedAttendance}%`;

    const computedAssignmentCompletion = calculateAssignmentCompletionPercent(studentCoursesData);
    assignmentCompconstion.textContent = computedAssignmentCompletion === null ? "-" : `${computedAssignmentCompletion}%`;

    const announcementsPreview = announcementsData.slice(0, 7);
    const tasksPreview = tasksData.slice(0, 7);

    announcementsPreview.forEach(announcement => {
        const announcementElement = document.createElement("div");
        announcementElement.className = "preview-announcement";

        announcementElement.innerHTML = `
            <span>
                <h3>${announcement["title"]}</h3>
                <p class="small unimportant">${announcement["content"]}</p>
                <p style="font-size: 0.7em;">${new Date(announcement["created_at"]).toLocaleDateString( )}</p>
            </span>
        `;

        announcementsList.appendChild(announcementElement);
    })

    tasksPreview.forEach(task => {
        const taskElement = document.createElement("div");
        taskElement.className = "task";

        let taskStatus;
        const deadline = new Date(task["dueDate"]);
        const now = new Date();
        if (task["completed"]) {
            taskElement.setAttribute("hidden", "true");
            taskStatus = "";
        } else if (now >= deadline) {
            taskStatus = "urgent";
        } else if ((deadline - now) / (1000 * 60 * 60 * 24) <= 3) {
            taskStatus = "close";
        }

        taskElement.innerHTML = `
            <div class="unfilled-circle ${taskStatus}"></div>
            <span>
                <h3>${task["title"]}</h3>
                <p class="${taskStatus}">Due: ${deadline.toLocaleDateString()}</p>
            </span>
        `;

        tasksList.appendChild(taskElement);
    });

    const urgentCounter = document.querySelector("#due-tasks .urgent");
    if (urgentCounter) {
        const urgentCount = tasksData.filter(t => !t?.completed && new Date(t?.dueDate) <= new Date()).length;
        urgentCounter.textContent = `${urgentCount} Urgent`;
    }

    amountOfClasses = scheduleData.filter(cs => cs["day_of_week"] === weekdays[(new Date()).getDay()]).length;
    classesCount.textContent = `You have ${amountOfClasses} classes today.`;
});


