const announcementList = document.getElementById('announcements-list');
let announcementAndContent = new Map();
let originalContents = [];

async function fetchAnnouncements() {
    try {
        const response = await fetch('../backend/get_announcements.php');
        if (!response.ok) {
            throw new Error('Failed to fetch announcements');
        }
        const announcements = await response.json();
        return announcements;
    } catch (error) {
        console.error('Error fetching announcements:', error);
        return [];
    }
} 

fetchAnnouncements().then((announcements) => {
    announcements.forEach((announcement) => {
        const announcementCard = document.createElement('div');
        announcementCard.className = 'announcement';
        announcementCard.innerHTML = `
            <h2>${announcement.title}</h2>
            <p>${announcement.content}</p>
            <span class="announcement-date small unimportant">${new Date(announcement["created_at"]).toLocaleDateString()}</span>
        `;
        announcementList.appendChild(announcementCard);
    });

    for (const announcement of announcementList.children) {
        const contentElement = announcement.querySelector('p');
        let content = contentElement.textContent;
        originalContents.push(content);
        announcementAndContent.set(announcement, content);

        if (content.length > 500) {
            contentElement.innerHTML = content.substring(0, 450) + '<a class="more-link" href="#">...</a>';
        }
    }

    for (const [announcement, content] of announcementAndContent) {
        const moreLink = announcement.querySelector('.more-link');
        if (moreLink) {
            moreLink.addEventListener('click', (event) => {
                event.preventDefault();
                const contentElement = announcement.querySelector('p');
                contentElement.textContent = content;
            });
        }
    }
}).catch((error) => {
    console.error('Error processing announcements:', error);
});