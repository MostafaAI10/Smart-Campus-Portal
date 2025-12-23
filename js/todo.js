let tasks = [];  
let editId = null;

const API_BASE = "../backend/tasks";
const getUserId = () => {
  const raw = sessionStorage.getItem("id");
  const parsed = raw ? parseInt(raw, 10) : NaN;
  return Number.isFinite(parsed) ? parsed : null;
};

const titleInput = document.getElementById("title");
const typeInput = document.getElementById("type");
const dueDateInput = document.getElementById("dueDate");
const priorityInput = document.getElementById("priority");
const categoryInput = document.getElementById("category");
const addBtn = document.getElementById("addBtn");
const updateBtn = document.getElementById("updateBtn");
const cancelBtn = document.getElementById("cancelBtn");

const taskList = document.getElementById("taskList");
const todayList = document.getElementById("today");
const upcomingList = document.getElementById("upcoming");
const overdueList = document.getElementById("overdue");


addBtn.onclick = addTask;
updateBtn.onclick = updateTask;
cancelBtn.onclick = cancelEdit;

let draggedTask = null;

function fetchTasks() {
  const userId = getUserId();
  if (!userId) {
    console.error("Missing user id in sessionStorage");
    return;
  }

  fetch(`${API_BASE}/getTasks.php`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ userId })
  })
    .then(res => res.json())
    .then(data => {
      tasks = Array.isArray(data) ? data : [];
      render();
    })
    .catch(err => console.error("Error fetching tasks:", err));
}

function sendAddTask(task) {
  return fetch(`${API_BASE}/addTask.php`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(task)
  })
    .then(res => res.json())
    .catch(err => {
      console.error("Error adding task:", err);
      return null;
    });
}

function sendUpdateTask(task) {
  fetch(`${API_BASE}/updateTask.php`, {
    method: "POST",
    headers: {"Content-Type":"application/json"},
    body: JSON.stringify(task)
  }).catch(err => console.error("Error updating task:", err));
}

function sendDeleteTask(id) {
  fetch(`${API_BASE}/deleteTask.php`, {
    method: "POST",
    headers: {"Content-Type":"application/json"},
    body: JSON.stringify({id})
  }).catch(err => console.error("Error deleting task:", err));
}


async function addTask() {
  const task = getFormData();
  if (!task) return;

  const userId = getUserId();
  if (!userId) {
    alert("Missing user id. Please log in again.");
    return;
  }

  const today = new Date().toISOString().split("T")[0];
  if (task.dueDate && task.dueDate < today) {
    alert("Cannot add a task with past date");
    return;
  }


  const duplicate = tasks.find(t => 
    t.title === task.title &&
    t.type === task.type &&
    t.dueDate === task.dueDate &&
    t.priority === task.priority &&
    t.category === task.category
  );
  if (duplicate) {
    alert("A task with the same data already exists");
    return;
  }

  task.completed = false;

  const created = await sendAddTask({ ...task, userId });
  task.id = created && created.id ? created.id : Date.now();

  tasks.push(task);
  clearForm();
  render();
}

function updateTask() {
  const task = getFormData();
  if (!task) return;

  const index = tasks.findIndex(t => t.id === editId);
  tasks[index] = {...tasks[index], ...task};
  sendUpdateTask(tasks[index]);
  editId = null;
  toggleEditButtons(false);
  clearForm();
  render();
}

function cancelEdit() {
  editId = null;
  toggleEditButtons(false);
  clearForm();
}

function getFormData() {
  const title = titleInput.value.trim();
  const type = typeInput.value;
  const dueDate = dueDateInput.value;
  const priority = priorityInput.value;
  const category = categoryInput.value.trim();

  if (!title) { alert("Task title is required"); return null; }
  if (!type) { alert("Select type is required"); return null; }
  if (!priority) { alert("Priority is required"); return null; }
  if (!category) { alert("Category is required"); return null; }

  return {title, type, dueDate, priority, category};
}

function editTask(id) {
  const task = tasks.find(t => t.id === id);
  editId = id;
  titleInput.value = task.title;
  typeInput.value = task.type;
  dueDateInput.value = task.dueDate;
  priorityInput.value = task.priority;
  categoryInput.value = task.category;
  toggleEditButtons(true);
}

function toggleEditButtons(editing) {
  addBtn.style.display = editing ? "none" : "inline-block";
  updateBtn.style.display = editing ? "inline-block" : "none";
  cancelBtn.style.display = editing ? "inline-block" : "none";
}

function toggleComplete(id) {
  const task = tasks.find(t => t.id === id);
  task.completed = !task.completed;
  sendUpdateTask(task);
  render();
}

function deleteTask(id) {
  if (!confirm("Are you sure you want to delete this task?")) return;
  tasks = tasks.filter(t => t.id !== id);
  sendDeleteTask(id);
  render();
}

function clearForm() {
  titleInput.value = "";
  typeInput.value = "";
  dueDateInput.value = "";
  priorityInput.value = "";
  categoryInput.value = "";
}


function render() {
  taskList.innerHTML = "";
  todayList.innerHTML = "";
  upcomingList.innerHTML = "";
  overdueList.innerHTML = "";

  const today = new Date().toISOString().split("T")[0];
  const tomorrow = new Date();
  tomorrow.setDate(tomorrow.getDate() + 1);
  const tomorrowStr = tomorrow.toISOString().split("T")[0];

  tasks.forEach(task => {
    const li = document.createElement("li");
    li.className = `task ${task.priority} ${task.completed ? "completed" : ""}`;
    li.setAttribute("draggable","true");

    li.innerHTML = `
      <span>${task.title} | ${task.type} | ${task.category} | ${task.dueDate || ""}</span>
      <div class="task-actions">
        <button onclick="toggleComplete(${task.id})">${task.completed ? "✔" : "Mark Completed"}</button>
        <button onclick="editTask(${task.id})">Edit</button>
        <button onclick="deleteTask(${task.id})">Delete</button>
      </div>
    `;

    
    li.addEventListener("dragstart", () => draggedTask = task);
    li.addEventListener("dragend", () => draggedTask = null);
    li.addEventListener("dragover", e => e.preventDefault());
    li.addEventListener("drop", () => {
      const idx1 = tasks.indexOf(draggedTask);
      const idx2 = tasks.indexOf(task);
      tasks.splice(idx1,1);
      tasks.splice(idx2,0,draggedTask);
      render();
    });

    taskList.appendChild(li);

    if (task.completed) return; 

    if (task.dueDate === today) todayList.appendChild(li.cloneNode(true));
    else if (task.dueDate === tomorrowStr || task.dueDate > today) upcomingList.appendChild(li.cloneNode(true));
    else if (task.dueDate < today && !task.completed) overdueList.appendChild(li.cloneNode(true));
  });
}


function sendUpdateTaskOrder() {
  // Ordering is currently client-side only.
}


fetchTasks();
