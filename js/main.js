const navButtons = document.getElementById("nav-components");
const collapseExpandBtn = document.getElementById("collapse-expand-btn");
const sideNav = document.getElementById("side-navigation");
const currentPage = window.location.pathname.split("/").pop().split(".")[0];
const profileFooter = document.querySelector("#side-navigation span:last-child");

if (sessionStorage.getItem("role") !== "student") {
    
}

if (sessionStorage.getItem("id") === null) {
    window.location.href = "../login.html";
}

if (sessionStorage.getItem("sideNavState") === "collapsed") {
    sideNav.classList.toggle("collapsed");
    sideNav.classList.toggle("expanded");
} 
navButtons.addEventListener("click", (event) => {
    if (event.target === navButtons) return;
    const target = event.target;
    window.location.href = `${target.id}.html`;
});

collapseExpandBtn.addEventListener("click", () => {
    sideNav.classList.toggle("collapsed");
    sideNav.classList.toggle("expanded");    
});

for (const button of navButtons.children) {
    if (button.id === currentPage) {
        button.classList.add("no-hover");
        button.classList.add("current-page");
        break;
    }
}   

profileFooter.innerHTML = `
    <div class="horizontal-break"></div>
        <div id="nav-footer">
            <img src="../assets/images/${sessionStorage.getItem("profile_picture")}" alt="user-img">
            <span>
                <p>${sessionStorage.getItem("first_name")} ${sessionStorage.getItem("last_name")} - ${sessionStorage.getItem("id")}</p>
                <p>${sessionStorage.getItem("role").split("").map((c, i) => i == 0 ? c.toUpperCase() : c).join("")}</p>
                <p><a href="#">Logout</a></p>
            </span>
    </div>
`
profileFooter.querySelector("a").addEventListener("click", (e) => {
    e.preventDefault();
    sessionStorage.clear();
    window.location.href = "../login.html";
});