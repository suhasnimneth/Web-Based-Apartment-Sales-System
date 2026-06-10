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
        <div class="card"><h3>Edit Profile</h3><p>Update your personal details here.</p></div>
      `;
            break;
        case "favourites":
            content.innerHTML = `
        <div class="card"><h3>Favourites</h3><p>View and manage your saved apartments.</p></div>
      `;
            break;
        case "bookings":
            content.innerHTML = `
        <div class="card"><h3>Bookings</h3><p>Track your apartment viewing schedules.</p></div>
      `;
            break;
        case "payments":
            content.innerHTML = `
        <div class="card"><h3>Payments</h3><p>Check your past and upcoming payments.</p></div>
      `;
            break;
        case "reviews":
            content.innerHTML = `
        <div class="card"><h3>Reviews</h3><p>See and edit reviews you have posted.</p></div>
      `;
            break;
        case "cards":
            content.innerHTML = `
        <div class="card"><h3>Add New Card</h3><p>Save your card details for quick payments.</p></div>
      `;
            break;
        case "settings":
            content.innerHTML = `
        <div class="card"><h3>Account Settings</h3><p>You can delete your account here.</p></div>
      `;
            break;
        default:
            content.innerHTML = `
        <div class="card"><h3>Buyer Dashboard</h3><p>Welcome back! Manage bookings, payments, and favourites here.</p></div>
      `;
    }
}
