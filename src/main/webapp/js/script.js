// Mobile menu toggle
const menuToggle = document.getElementById("menu-toggle");
const navLinks = document.getElementById("nav-links");

menuToggle.addEventListener("click", () => {
    navLinks.classList.toggle("show");
    menuToggle.innerHTML = navLinks.classList.contains("show")
        ? '<i class="fa-solid fa-xmark"></i>'
        : '<i class="fa-solid fa-bars"></i>';
});

// Hero Slider
const slider = document.getElementById("slider");
const slides = document.querySelectorAll(".slide");

let index = 0;
let slideInterval;

function showSlide(i) {
    index = (i + slides.length) % slides.length;
    slider.style.transform = `translateX(${-index * 100}%)`;
}

function nextSlide() {
    showSlide(index + 1);
}

function startSlideShow() {
    slideInterval = setInterval(nextSlide, 3000); // ✅ 2 seconds
}

function stopSlideShow() {
    clearInterval(slideInterval);
}

// ✅ Removed manual next/prev button event listeners

// Pause slider on hover
slider.addEventListener("mouseenter", stopSlideShow);
slider.addEventListener("mouseleave", startSlideShow);

// Initialize
showSlide(index);
startSlideShow();

// Fade-in animation for Why Choose Us cards
const chooseCards = document.querySelectorAll(".choose-card");

function showCardsOnScroll() {
    const triggerBottom = window.innerHeight * 0.85;
    chooseCards.forEach(card => {
        const cardTop = card.getBoundingClientRect().top;
        if (cardTop < triggerBottom) {
            card.classList.add("show");
        }
    });
}

// Parallax effect for background blur circles
function parallaxEffect() {
    const scrolled = window.pageYOffset;
    const blurCircles = document.querySelectorAll('.blur-circle');

    blurCircles.forEach((circle, index) => {
        const speed = 0.05 * (index + 1);
        const yPos = -(scrolled * speed);
        circle.style.transform = `translateY(${yPos}px)`;
    });
}

// Event listeners for scroll effects
window.addEventListener("scroll", () => {
    showCardsOnScroll();
    parallaxEffect();
});

window.addEventListener("load", () => {
    showCardsOnScroll();
    parallaxEffect();
});

// Add smooth scrolling to all links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            target.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    });
});
