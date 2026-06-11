// Sidebar active state toggle
document.querySelectorAll(".sidebar nav ul li").forEach((item) => {
    item.addEventListener("click", () => {
        document.querySelectorAll(".sidebar nav ul li").forEach((li) =>
            li.classList.remove("active")
        );
        item.classList.add("active");

        // Load section dynamically
        const section = item.getAttribute("data-section");
        loadSection(section);
    });
});

function loadSection(section) {
    const content = document.getElementById("content-area");
    if (!content) return;

    switch (section) {
        case "profile":
            content.innerHTML = `
        <div class="card"><h3>Edit Profile</h3><p>Update your seller details here.</p></div>
      `;
            break;
        case "apartments":
            content.innerHTML = `
        <div class="card"><h3>Your Apartments</h3><p>Manage, update or delete your apartments.</p></div>
      `;
            break;
        case "add-apartment":
            content.innerHTML = `
        <div class="card"><h3>Add New Apartment</h3><p>Upload apartment details and images here.</p></div>
      `;
            break;
        case "payments":
            content.innerHTML = `
        <div class="card"><h3>Payments</h3><p>See payment messages when buyers make advance payments.</p></div>
      `;
            break;
        case "bookings":
            content.innerHTML = `
        <div class="card"><h3>Bookings</h3><p>See buyer visit schedules here.</p></div>
      `;
            break;
        case "reviews":
            content.innerHTML = `
        <div class="card"><h3>Reviews</h3><p>Read buyer feedback on your apartments.</p></div>
      `;
            break;
        case "settings":
            content.innerHTML = `
        <div class="card"><h3>Account Settings</h3><p>Delete or update your account here.</p></div>
      `;
            break;
        default:
            content.innerHTML = `
        <div class="card"><h3>Seller Dashboard</h3><p>Welcome back! Manage your apartments, bookings, and payments.</p></div>
      `;
    }
}
