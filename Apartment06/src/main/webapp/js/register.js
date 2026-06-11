// Form submission
document.getElementById("registerForm").addEventListener("submit", function(e){
    e.preventDefault();
    const firstName = document.getElementById("firstName").value.trim();
    const lastName = document.getElementById("lastName").value.trim();
    const contactNo = document.getElementById("contactNo").value.trim();
    const email = document.getElementById("email").value.trim();
    const password = document.getElementById("password").value.trim();
    const dob = document.getElementById("dob").value;
    const role = document.getElementById("role").value;

    if(!role){
        alert("Please select a role");
        return;
    }

    alert(`Registered successfully as ${role}!\nWelcome ${firstName} ${lastName}`);
    this.reset();
});

// Go back
function goBack(){
    window.history.back();
}

// Image banner auto-change
let bannerImages = document.querySelectorAll('.banner-image');
let current = 0;

function nextImage() {
    bannerImages[current].classList.remove('active');
    current = (current + 1) % bannerImages.length;
    bannerImages[current].classList.add('active');
}

setInterval(nextImage, 4000); // change every 4s
