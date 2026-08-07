<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us | Apartment X</title>
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: "Poppins", sans-serif;
            background: #f8f8f8;
            color: #333;
            line-height: 1.6;
        }

        /* Header */
        .page-header {
            background: linear-gradient(135deg, #fff, #fef2f2);
            padding: 40px 30px;
            text-align: center;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .page-header h1 {
            margin: 0;
            color: #333;
            font-size: 2.5rem;
        }
        .page-header span {
            color: #e63946;
        }
        .page-header p {
            margin-top: 10px;
            color: #666;
            font-size: 1.1rem;
        }

        /* Back Button */
        .back-btn {
            position: absolute;
            left: 20px;
            top: 20px;
            background: transparent;
            color: #e63946;
            border: 2px solid #e63946;
            padding: 0.8rem 1.5rem;
            border-radius: 25px;
            cursor: pointer;
            font-size: 1rem;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }
        .back-btn:hover {
            background: #e63946;
            color: white;
            transform: translateY(-2px);
        }

        /* Main Container */
        .contact-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 40px 20px;
        }

        /* Contact Grid */
        .contact-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 40px;
            margin-bottom: 50px;
        }

        /* Contact Information */
        .contact-info {
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.08);
        }

        .contact-info h2 {
            color: #e63946;
            margin-bottom: 30px;
            font-size: 1.8rem;
        }

        .contact-item {
            display: flex;
            align-items: center;
            margin-bottom: 25px;
            padding: 15px;
            background: #f8f8f8;
            border-radius: 10px;
            transition: background 0.3s ease;
        }

        .contact-item:hover {
            background: #f0f0f0;
        }

        .contact-icon {
            width: 50px;
            height: 50px;
            background: #e63946;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 20px;
            color: white;
            font-size: 1.2rem;
        }

        .contact-details h3 {
            margin: 0 0 5px;
            color: #333;
            font-size: 1.1rem;
        }

        .contact-details p {
            margin: 0;
            color: #666;
            font-size: 0.95rem;
        }

        /* Contact Form */
        .contact-form {
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.08);
        }

        .contact-form h2 {
            color: #e63946;
            margin-bottom: 30px;
            font-size: 1.8rem;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 600;
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 1rem;
            transition: border-color 0.3s ease;
            font-family: inherit;
        }

        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #e63946;
        }

        .form-group textarea {
            resize: vertical;
            min-height: 120px;
        }

        .submit-btn {
            background: #e63946;
            color: white;
            border: none;
            padding: 15px 30px;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.3s ease;
            width: 100%;
        }

        .submit-btn:hover {
            background: #c92e3d;
            transform: translateY(-2px);
        }

        /* Office Hours */
        .office-hours {
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.08);
            margin-bottom: 40px;
        }

        .office-hours h2 {
            color: #e63946;
            margin-bottom: 30px;
            font-size: 1.8rem;
            text-align: center;
        }

        .hours-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }

        .hours-item {
            text-align: center;
            padding: 20px;
            background: #f8f8f8;
            border-radius: 10px;
        }

        .hours-item h3 {
            color: #333;
            margin-bottom: 10px;
        }

        .hours-item p {
            color: #666;
            margin: 0;
        }

        /* Map Section */
        .map-section {
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.08);
            text-align: center;
        }

        .map-section h2 {
            color: #e63946;
            margin-bottom: 30px;
            font-size: 1.8rem;
        }

        .map-placeholder {
            width: 100%;
            height: 300px;
            background: #f0f0f0;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #666;
            font-size: 1.1rem;
            border: 2px dashed #ccc;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .page-header {
                padding: 30px 20px;
            }

            .page-header h1 {
                font-size: 2rem;
            }

            .contact-container {
                padding: 20px 15px;
            }

            .contact-grid {
                grid-template-columns: 1fr;
                gap: 30px;
            }

            .contact-info,
            .contact-form,
            .office-hours,
            .map-section {
                padding: 30px 20px;
            }

            .contact-item {
                flex-direction: column;
                text-align: center;
            }

            .contact-icon {
                margin-right: 0;
                margin-bottom: 15px;
            }

            .hours-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<!-- Header -->
<header class="page-header">
    <a href="index.jsp" class="back-btn"> Back</a>
    <h1>Contact <span>Us</span></h1>
    <p>Get in touch with our team - we're here to help you find your perfect apartment</p>
</header>

<!-- Main Content -->
<div class="contact-container">
    <!-- Contact Grid -->
    <div class="contact-grid">
        <!-- Contact Information -->
        <div class="contact-info">
            <h2>Get In Touch</h2>
            
            <div class="contact-item">
                <div class="contact-icon"><i class="fas fa-phone"></i></div>
                <div class="contact-details">
                    <h3>Phone</h3>
                    <p>+94 77 123 4567</p>
                </div>
            </div>

            <div class="contact-item">
                <div class="contact-icon"><i class="fas fa-envelope"></i></div>
                <div class="contact-details">
                    <h3>Email</h3>
                    <p>support@apartmentx.com</p>
                </div>
            </div>

            <div class="contact-item">
                <div class="contact-icon"><i class="fas fa-map-marker-alt"></i></div>
                <div class="contact-details">
                    <h3>Address</h3>
                    <p>123 Business Street<br>Colombo 03, Sri Lanka</p>
                </div>
            </div>

            <div class="contact-item">
                <div class="contact-icon"><i class="fab fa-whatsapp"></i></div>
                <div class="contact-details">
                    <h3>WhatsApp</h3>
                    <p>+94 77 123 4567</p>
                </div>
            </div>
        </div>

        <!-- Contact Form -->
        <div class="contact-form">
            <h2>Send Us a Message</h2>
            <form>
                <div class="form-group">
                    <label for="name">Full Name</label>
                    <input type="text" id="name" name="name" required>
                </div>

                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" required>
                </div>

                <div class="form-group">
                    <label for="phone">Phone Number</label>
                    <input type="tel" id="phone" name="phone">
                </div>

                <div class="form-group">
                    <label for="subject">Subject</label>
                    <input type="text" id="subject" name="subject" required>
                </div>

                <div class="form-group">
                    <label for="message">Message</label>
                    <textarea id="message" name="message" placeholder="Tell us how we can help you..." required></textarea>
                </div>

                <button type="submit" class="submit-btn">Send Message</button>
            </form>
        </div>
    </div>

    <!-- Office Hours -->
    <div class="office-hours">
        <h2>Office Hours</h2>
        <div class="hours-grid">
            <div class="hours-item">
                <h3>Monday - Friday</h3>
                <p>9:00 AM - 6:00 PM</p>
            </div>
            <div class="hours-item">
                <h3>Saturday</h3>
                <p>9:00 AM - 4:00 PM</p>
            </div>
            <div class="hours-item">
                <h3>Sunday</h3>
                <p>Closed</p>
            </div>
            <div class="hours-item">
                <h3>Emergency Support</h3>
                <p>24/7 Available</p>
            </div>
        </div>
    </div>


</div>

<script>
    // Form submission handling
    document.querySelector('form').addEventListener('submit', function(e) {
        e.preventDefault();
        
        // Get form data
        const formData = new FormData(this);
        const name = formData.get('name');
        const email = formData.get('email');
        const subject = formData.get('subject');
        const message = formData.get('message');
        
        // Simple validation
        if (!name || !email || !subject || !message) {
            alert('Please fill in all required fields.');
            return;
        }
        
        // Show success message
        alert('Thank you for your message! We will get back to you soon.');
        
        // Reset form
        this.reset();
    });
</script>
</body>
</html>
