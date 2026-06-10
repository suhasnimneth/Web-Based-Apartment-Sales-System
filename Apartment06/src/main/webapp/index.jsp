<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.project.model.Review" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    // Get reviews data from request attributes
    List<Review> reviews = (List<Review>) request.getAttribute("reviews");
    Double averageRating = (Double) request.getAttribute("averageRating");
    Integer totalReviews = (Integer) request.getAttribute("totalReviews");
    
    if (reviews == null) {
        reviews = new java.util.ArrayList<>();
    }
    if (averageRating == null) {
        averageRating = 0.0;
    }
    if (totalReviews == null) {
        totalReviews = 0;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Apartment X</title>
    <link rel="stylesheet" href="css/style.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<!-- Background Blur Elements -->
<div class="blur-circle blur-circle-1"></div>
<div class="blur-circle blur-circle-2"></div>
<div class="blur-circle blur-circle-3"></div>

<!-- Header / Navbar -->
<header>
    <nav class="navbar">
        <div class="logo">
            <i class="fa-solid fa-building"></i><a href="index.jsp" style="text-decoration:none"> Apartment </a> <span>X</span>
        </div>

        <ul class="nav-links" id="nav-links">
            <li><a href="index.jsp">Home</a></li>
            <li><a href="ReviewsServlet">Reviews</a></li>
            <li><a href="about.jsp">About</a></li>
            <li><a href="contact.jsp">Contact</a></li>
            <li><a href="faq.jsp">FAQ</a></li>
            <li><a href="login.jsp" class="login-btn"><i class="fa-solid fa-user"></i> Login</a></li>
            <li><a href="register.jsp" class="login-btn"><i class="fa-solid fa-user"></i> Register</a></li>
        </ul>

        <!-- Mobile Menu Button -->
        <div class="menu-toggle" id="menu-toggle">
            <i class="fa-solid fa-bars"></i>
        </div>
    </nav>
</header>

<!-- Hero Banner Slider -->
<section class="hero-banner">
    <div class="slider" id="slider">
        <div class="slide">
            <img src="https://doudapartmenthomes.com/wp-content/uploads/2023/12/sidekix-media-LFlbLb8vJls-unsplash-scaled.jpg" alt="Apartment 1">
            <div class="banner-text">
                <h2>Find Your <span>Dream Apartment</span></h2>
                <p>Discover stylish apartments with comfort and affordability.</p>
                <a href="login.jsp" class="banner-btn">Browse Now</a>
            </div>
        </div>

        <div class="slide">
            <img src="https://images.pexels.com/photos/439391/pexels-photo-439391.jpeg" alt="Apartment 2">
            <div class="banner-text">
                <h2>Modern <span>Living</span></h2>
                <p>Enjoy premium facilities and the best city locations.</p>
                <a href="login.jsp" class="banner-btn">Explore</a>
            </div>
        </div>

        <div class="slide">
            <img src="https://www.rustomjee.com/blog/wp-content/uploads/2024/10/Defining-Luxury-in-the-Context-of-Apartments-scaled-1.jpg" alt="Apartment 3">
            <div class="banner-text">
                <h2>Secure & <span>Easy Booking</span></h2>
                <p>Book your dream apartment in just a few clicks.</p>
                <a href="login.jsp" class="banner-btn">Book Now</a>
            </div>
        </div>
    </div>
</section>

<!-- Featured Listings Section -->
<section class="featured-listings">
    <div class="container">
        <h2 class="section-title"> Featured <span>Listings</span></h2>
        <div class="listings-grid">
            <!-- Apartment Card -->
            <div class="listing-card">
                <img src="https://images.pexels.com/photos/439391/pexels-photo-439391.jpeg" alt="Apartment 1">
                <div class="card-content">
                    <h3>Luxury Apartment</h3>
                    <p class="price">$120,000</p>
                    <p>2 Beds | 2 Baths | 1100 sqft</p>
                    <a href="login.jsp" class="card-btn">View More</a>
                </div>
            </div>

            <div class="listing-card">
                <img src="https://archipro.com.au/images/cdn-images/width%3D3840%2Cquality%3D80/images/s1/article/building/Form-Apartments-Port-Coogee-by-Stiebel-Eltron--v2.jpg/eyJlZGl0cyI6W3sidHlwZSI6InpwY2YiLCJvcHRpb25zIjp7ImJveFdpZHRoIjoyODgwLCJib3hIZWlnaHQiOjE4NTYsImNvdmVyIjp0cnVlLCJ6b29tV2lkdGgiOjI4ODAsInNjcm9sbFBvc1giOjUwLCJzY3JvbGxQb3NZIjo1MCwiYmFja2dyb3VuZCI6InJnYigxMTUsMTQwLDE5NCkiLCJmaWx0ZXIiOjB9fV0sInF1YWxpdHkiOjg3fQ==" alt="Apartment 2">
                <div class="card-content">
                    <h3>Modern Studio</h3>
                    <p class="price">$85,000</p>
                    <p>1 Bed | 1 Bath | 600 sqft</p>
                    <a href="login.jsp" class="card-btn">View More</a>
                </div>
            </div>

            <div class="listing-card">
                <img src="https://images.pexels.com/photos/439391/pexels-photo-439391.jpeg" alt="Apartment 3">
                <div class="card-content">
                    <h3>Family Apartment</h3>
                    <p class="price">$150,000</p>
                    <p>3 Beds | 2 Baths | 1400 sqft</p>
                    <a href="login.jsp" class="card-btn">View More</a>
                </div>
            </div>

            <div class="listing-card">
                <img src="https://archipro.com.au/images/cdn-images/width%3D3840%2Cquality%3D80/images/s1/article/building/Form-Apartments-Port-Coogee-by-Stiebel-Eltron--v2.jpg/eyJlZGl0cyI6W3sidHlwZSI6InpwY2YiLCJvcHRpb25zIjp7ImJveFdpZHRoIjoyODgwLCJib3hIZWlnaHQiOjE4NTYsImNvdmVyIjp0cnVlLCJ6b29tV2lkdGgiOjI4ODAsInNjcm9sbFBvc1giOjUwLCJzY3JvbGxQb3NZIjo1MCwiYmFja2dyb3VuZCI6InJnYigxMTUsMTQwLDE5NCkiLCJmaWx0ZXIiOjB9fV0sInF1YWxpdHkiOjg3fQ==" alt="Apartment 4">
                <div class="card-content">
                    <h3>City View Flat</h3>
                    <p class="price">$98,000</p>
                    <p>2 Beds | 1 Bath | 900 sqft</p>
                    <a href="login.jsp" class="card-btn">View More</a>
                </div>
            </div>

            <div class="listing-card">
                <img src="https://images.pexels.com/photos/439391/pexels-photo-439391.jpeg" alt="Apartment 5">
                <div class="card-content">
                    <h3>Elegant Condo</h3>
                    <p class="price">$175,000</p>
                    <p>3 Beds | 3 Baths | 1600 sqft</p>
                    <a href="login.jsp" class="card-btn">View More</a>
                </div>
            </div>

            <div class="listing-card">
                <img src="https://archipro.com.au/images/cdn-images/width%3D3840%2Cquality%3D80/images/s1/article/building/Form-Apartments-Port-Coogee-by-Stiebel-Eltron--v2.jpg/eyJlZGl0cyI6W3sidHlwZSI6InpwY2YiLCJvcHRpb25zIjp7ImJveFdpZHRoIjoyODgwLCJib3hIZWlnaHQiOjE4NTYsImNvdmVyIjp0cnVlLCJ6b29tV2lkdGgiOjI4ODAsInNjcm9sbFBvc1giOjUwLCJzY3JvbGxQb3NZIjo1MCwiYmFja2dyb3VuZCI6InJnYigxMTUsMTQwLDE5NCkiLCJmaWx0ZXIiOjB9fV0sInF1YWxpdHkiOjg3fQ==" alt="Apartment 6">
                <div class="card-content">
                    <h3>Cozy Apartment</h3>
                    <p class="price">$70,000</p>
                    <p>1 Bed 0 | 1 Bath | 500 sqft</p>
                    <a href="login.jsp" class="card-btn">View More</a>
                </div>
            </div>

            <div class="listing-card">
                <img src="https://img.freepik.com/free-photo/analog-landscape-city-with-buildings_23-2149661456.jpg" alt="Apartment 7">
                <div class="card-content">
                    <h3>Spacious Loft</h3>
                    <p class="price">$140,000</p>
                    <p>2 Beds | 2 Baths | 1200 sqft</p>
                    <a href="login.jsp" class="card-btn">View More</a>
                </div>
            </div>

            <div class="listing-card">
                <img src="https://lscdn.blob.core.windows.net/property/realestatead/12_05_2025_14_15_23_74174.jpg" alt="Apartment 8">
                <div class="card-content">
                    <h3>Riverside Flat</h3>
                    <p class="price">$110,000</p>
                    <p>2 Beds | 1 Bath | 1000 sqft</p>
                    <a href="login.jsp" class="card-btn">View More</a>
                </div>
            </div>

            <div class="listing-card">
                <img src="https://archipro.com.au/images/cdn-images/width%3D3840%2Cquality%3D80/images/s1/article/building/Form-Apartments-Port-Coogee-by-Stiebel-Eltron--v2.jpg/eyJlZGl0cyI6W3sidHlwZSI6InpwY2YiLCJvcHRpb25zIjp7ImJveFdpZHRoIjoyODgwLCJib3hIZWlnaHQiOjE4NTYsImNvdmVyIjp0cnVlLCJ6b29tV2lkdGgiOjI4ODAsInNjcm9sbFBvc1giOjUwLCJzY3JvbGxQb3NZIjo1MCwiYmFja2dyb3VuZCI6InJnYigxMTUsMTQwLDE5NCkiLCJmaWx0ZXIiOjB9fV0sInF1YWxpdHkiOjg3fQ==" alt="Apartment 6">
                <div class="card-content">
                    <h3>Cozy Apartment</h3>
                    <p class="price">$70,000</p>
                    <p>1 Bed | 1 Bath | 500 sqft</p>
                    <a href="login.jsp" class="card-btn">View More</a>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Call to Action Section -->
<section class="cta-section">
    <div class="cta-container">
        <h2>Want to see Reviews & Ratings?</h2>
        <p>Join thousands of buyers and explore the best listings today with Apartment X.</p>
        <a href="ReviewsServlet" class="cta-btn">View Reviews</a>
    </div>
</section>

<!-- Why Choose Us Section -->
<section class="why-choose">
    <div class="container">
        <h2 class="section-title"> Why <span>Choose Us</span></h2>
        <div class="choose-grid">
            <div class="choose-card">
                <i class="fa-solid fa-building"></i>
                <h3>Wide Range of Apartments</h3>
                <p>We offer a variety of apartments that suit every budget and lifestyle, from cozy studios to luxury condos.</p>
            </div>

            <div class="choose-card">
                <i class="fa-solid fa-shield-halved"></i>
                <h3>Trusted & Secure</h3>
                <p>Your safety is our priority. Verified listings and secure booking ensure peace of mind.</p>
            </div>

            <div class="choose-card">
                <i class="fa-solid fa-handshake"></i>
                <h3>Easy Booking</h3>
                <p>Find, compare, and book apartments in just a few clicks with our user-friendly system.</p>
            </div>

            <div class="choose-card">
                <i class="fa-solid fa-headset"></i>
                <h3>24/7 Support</h3>
                <p>Our dedicated support team is available anytime to answer your queries and assist you.</p>
            </div>
        </div>
    </div>
</section>



<!-- Footer Section -->
<footer class="footer">
    <div class="footer-container">
        <!-- About -->
        <div class="footer-col">
            <h3>Apartment <span>X</span></h3>
            <p>Your trusted platform to find, compare, and book the best apartments in town.</p>
        </div>

        <!-- Quick Links -->
        <div class="footer-col">
            <h4>Quick Links</h4>
            <ul>
                <li><a href="index.jsp">Home</a></li>
                <li><a href="login.jsp">Listings</a></li>
                <li><a href="about.jsp">Why Choose Us</a></li>
                <li><a href="contact.jsp">Contact</a></li>
            </ul>
        </div>

        <!-- Contact -->
        <div class="footer-col">
            <h4>Contact</h4>
            <p><i class="fa-solid fa-phone"></i> +94 70 555 0374</p>
            <p><i class="fa-solid fa-envelope"></i> support@apartmentx.com</p>
            <p><i class="fa-solid fa-location-dot"></i> Matara, Sri Lanka</p>
        </div>

        <!-- Socials -->
        <div class="footer-col">
            <h4>Follow Us</h4>
            <div class="social-links">
                <a href="#"><i class="fa-brands fa-facebook"></i></a>
                <a href="#"><i class="fa-brands fa-twitter"></i></a>
                <a href="#"><i class="fa-brands fa-instagram"></i></a>
                <a href="#"><i class="fa-brands fa-linkedin"></i></a>
            </div>
        </div>
    </div>

    <div class="footer-bottom">
        <p>© 2025 Apartment X. All Rights Reserved.</p>
    </div>
</footer>

<script src="js/script.js"></script>
</body>
</html>