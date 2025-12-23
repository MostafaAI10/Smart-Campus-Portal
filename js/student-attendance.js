const attendanceTable = document.querySelector("table");

fetch('../backend/get_student_attendance.php', {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json'
    },
    body: JSON.stringify({ id: sessionStorage.getItem('id') })
}).then((response) => {
    return response.json();
}).then((data) => {
    data.forEach((attendance) => {
        const row = document.createElement('tr');
        let attendancePercentage = attendance.total_classes > 0 ? ((attendance.attended_classes / attendance.total_classes) * 100).toFixed(2) : '0.00';
        row.innerHTML = `
            <td>${attendance.course_code}</td>
            <td>${attendance.course_name}</td>
            <td>${attendance.total_classes}</td>
            <td>${attendance.attended_classes}</td>
            <td>${attendancePercentage}%</td>
        `;
        attendanceTable.appendChild(row);
    });
}).catch((error) => {
    console.error('Error fetching attendance data:', error);
});
    