-- ==============================================================
-- DATABASE SETUP FOR APARTMENT X SYSTEM
-- ==============================================================

-- ==============================================================
-- USERS
-- ==============================================================

CREATE SEQUENCE dbo.SeqUsers AS INT START WITH 1 INCREMENT BY 1;
GO

CREATE TABLE dbo.users (
                           userId VARCHAR(10) NOT NULL DEFAULT ('U' + RIGHT('000' + CAST(NEXT VALUE FOR dbo.SeqUsers AS VARCHAR(10)), 3)),
                           firstName NVARCHAR(100) NOT NULL,
                           lastName NVARCHAR(100) NOT NULL,
                           contactNumber NVARCHAR(20),
                           address NVARCHAR(255),
                           email NVARCHAR(150) NOT NULL UNIQUE,
                           password NVARCHAR(255) NOT NULL,
                           dateOfBirth DATE NOT NULL,
                           role NVARCHAR(20) NOT NULL CHECK (role IN ('buyer','seller')),
                           registrationDate DATETIME2 NOT NULL,
                           CONSTRAINT PK_users PRIMARY KEY (userId)
);

CREATE INDEX IX_users_role ON dbo.users(role);
GO

-- ==============================================================
-- BUYERS & SELLERS
-- ==============================================================

CREATE SEQUENCE dbo.SeqBuyers AS INT START WITH 1 INCREMENT BY 1;
GO

CREATE TABLE dbo.buyers (
                            buyerId VARCHAR(10) NOT NULL DEFAULT ('B' + RIGHT('000' + CAST(NEXT VALUE FOR dbo.SeqBuyers AS VARCHAR(10)), 3)),
                            userId VARCHAR(10) NOT NULL UNIQUE,
                            preferredLocation NVARCHAR(100),
                            budgetRange DECIMAL(18,2),
                            purchaseTimeline NVARCHAR(50),
                            CONSTRAINT PK_buyers PRIMARY KEY (buyerId),
                            CONSTRAINT FK_buyers_users FOREIGN KEY (userId) REFERENCES dbo.users(userId) ON DELETE CASCADE
);

CREATE INDEX IX_buyers_preferredLocation ON dbo.buyers(preferredLocation);
GO





CREATE SEQUENCE dbo.SeqSellers AS INT START WITH 1 INCREMENT BY 1;
GO

CREATE TABLE dbo.sellers (
                             sellerId VARCHAR(10) NOT NULL DEFAULT ('S' + RIGHT('000' + CAST(NEXT VALUE FOR dbo.SeqSellers AS VARCHAR(10)), 3)),
                             userId VARCHAR(10) NOT NULL UNIQUE,
                             businessRegistrationNumber NVARCHAR(100),
                             companyName NVARCHAR(150),
                             licenseNumber NVARCHAR(100),
                             CONSTRAINT PK_sellers PRIMARY KEY (sellerId),
                             CONSTRAINT FK_sellers_users FOREIGN KEY (userId) REFERENCES dbo.users(userId) ON DELETE CASCADE
);

CREATE INDEX IX_sellers_companyName ON dbo.sellers(companyName);
GO

-- ==============================================================
-- APARTMENTS & IMAGES
-- ==============================================================

CREATE SEQUENCE dbo.SeqApartments AS INT START WITH 1 INCREMENT BY 1;
GO

CREATE TABLE dbo.apartments (
                                apartmentId VARCHAR(10) NOT NULL DEFAULT ('A' + RIGHT('000' + CAST(NEXT VALUE FOR dbo.SeqApartments AS VARCHAR(10)), 3)),
                                sellerId VARCHAR(10) NOT NULL,
                                title NVARCHAR(150) NOT NULL,
                                description NVARCHAR(MAX),
                                address NVARCHAR(255) NOT NULL,
                                city NVARCHAR(100) NOT NULL,
                                state NVARCHAR(100),
                                postalCode NVARCHAR(20),
                                contactNumber NVARCHAR(20),
                                propertyType NVARCHAR(50),
                                price DECIMAL(18,2) NOT NULL,
                                bedrooms INT,
                                bathrooms INT,
                                areaSqFt INT,
                                status NVARCHAR(20) DEFAULT 'Available',
                                createdAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
                                CONSTRAINT PK_apartments PRIMARY KEY (apartmentId),
                                CONSTRAINT FK_apartments_sellers FOREIGN KEY (sellerId) REFERENCES dbo.sellers(sellerId) ON DELETE CASCADE
);

CREATE INDEX IX_apartments_seller ON dbo.apartments(sellerId);
CREATE INDEX IX_apartments_city ON dbo.apartments(city);
GO


CREATE SEQUENCE dbo.SeqApartmentImages AS INT START WITH 1 INCREMENT BY 1;
GO

CREATE TABLE dbo.apartment_images (
                                      imageId VARCHAR(10) NOT NULL DEFAULT ('I' + RIGHT('000' + CAST(NEXT VALUE FOR dbo.SeqApartmentImages AS VARCHAR(10)), 3)),
                                      apartmentId VARCHAR(10) NOT NULL,
                                      imageUrl NVARCHAR(500) NOT NULL,
                                      createdAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
                                      CONSTRAINT PK_apartment_images PRIMARY KEY (imageId),
                                      CONSTRAINT FK_apartment_images_apartments FOREIGN KEY (apartmentId) REFERENCES dbo.apartments(apartmentId) ON DELETE CASCADE
);

CREATE INDEX IX_apartment_images_apartment ON dbo.apartment_images(apartmentId);
GO

-- ==============================================================
-- FAVOURITES
-- ==============================================================

CREATE SEQUENCE dbo.SeqFavourites AS INT START WITH 1 INCREMENT BY 1;
GO

CREATE TABLE dbo.favourites (
                                favouriteId VARCHAR(10) NOT NULL DEFAULT ('F' + RIGHT('000' + CAST(NEXT VALUE FOR dbo.SeqFavourites AS VARCHAR(10)), 3)),
                                buyerId VARCHAR(10) NOT NULL,
                                apartmentId VARCHAR(10) NOT NULL,
                                createdAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
                                CONSTRAINT PK_favourites PRIMARY KEY (favouriteId),
                                CONSTRAINT FK_favourites_buyers FOREIGN KEY (buyerId) REFERENCES dbo.buyers(buyerId) ON DELETE CASCADE,
                                CONSTRAINT FK_favourites_apartments FOREIGN KEY (apartmentId) REFERENCES dbo.apartments(apartmentId),
                                CONSTRAINT UQ_favourites UNIQUE (buyerId, apartmentId)
);

CREATE INDEX IX_favourites_buyer ON dbo.favourites(buyerId);
CREATE INDEX IX_favourites_apartment ON dbo.favourites(apartmentId);
GO

-- ==============================================================
-- BOOKINGS
-- ==============================================================

CREATE SEQUENCE dbo.SeqBookings AS INT START WITH 1 INCREMENT BY 1;
GO

CREATE TABLE dbo.bookings (
                              bookingId VARCHAR(10) NOT NULL DEFAULT ('BKNG' + RIGHT('000' + CAST(NEXT VALUE FOR dbo.SeqBookings AS VARCHAR(10)), 3)),
                              buyerId VARCHAR(10) NOT NULL,
                              sellerId VARCHAR(10) NOT NULL,
                              apartmentId VARCHAR(10) NOT NULL,
                              bookingDate DATE NOT NULL CHECK (bookingDate >= CAST(GETDATE() AS DATE)),
                              bookingTime TIME NOT NULL,
                              message NVARCHAR(500),
                              status NVARCHAR(20) NOT NULL DEFAULT 'Pending' CHECK (status IN ('Pending','Confirmed','Cancelled','Completed')),
                              createdAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
                              updatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
                              CONSTRAINT PK_bookings PRIMARY KEY (bookingId),
                              CONSTRAINT FK_bookings_buyers FOREIGN KEY (buyerId) REFERENCES dbo.buyers(buyerId),
                              CONSTRAINT FK_bookings_sellers FOREIGN KEY (sellerId) REFERENCES dbo.sellers(sellerId),
                              CONSTRAINT FK_bookings_apartments FOREIGN KEY (apartmentId) REFERENCES dbo.apartments(apartmentId),
                              CONSTRAINT UQ_bookings_apartment_datetime UNIQUE (apartmentId, bookingDate, bookingTime)
);
GO

-- ==============================================================
-- BUYER CARDS
-- ==============================================================

CREATE SEQUENCE dbo.SeqBuyerCards AS INT START WITH 1 INCREMENT BY 1;
GO

CREATE TABLE dbo.buyerCards (
                                buyerCardId VARCHAR(10) NOT NULL DEFAULT ('BC' + RIGHT('000' + CAST(NEXT VALUE FOR dbo.SeqBuyerCards AS VARCHAR(10)), 3)),
                                buyerId VARCHAR(10) NOT NULL,
                                cardholderName NVARCHAR(100) NOT NULL,
                                cardNumber NVARCHAR(19) NOT NULL,
                                cvv NVARCHAR(4) NOT NULL,
                                expiryDate DATE NOT NULL,
                                amountInCard DECIMAL(10,2) NOT NULL DEFAULT 0.00 CHECK (amountInCard >= 0),
                                createdAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
                                updatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
                                CONSTRAINT PK_buyerCards PRIMARY KEY (buyerCardId),
                                CONSTRAINT FK_buyerCards_buyers FOREIGN KEY (buyerId) REFERENCES dbo.buyers(buyerId) ON DELETE CASCADE
);

CREATE INDEX IX_buyerCards_buyer ON dbo.buyerCards(buyerId);
GO

-- ==============================================================
-- PAYMENTS
-- ==============================================================

CREATE SEQUENCE dbo.SeqPayments AS INT START WITH 1 INCREMENT BY 1;
GO

CREATE TABLE dbo.payments (
                              paymentId VARCHAR(10) NOT NULL DEFAULT ('PAY' + RIGHT('000' + CAST(NEXT VALUE FOR dbo.SeqPayments AS VARCHAR(10)), 3)),
                              buyerId VARCHAR(10) NOT NULL,
                              sellerId VARCHAR(10) NOT NULL,
                              apartmentId VARCHAR(10) NOT NULL,
                              buyerCardId VARCHAR(10) NOT NULL,
                              paymentType NVARCHAR(20) NOT NULL CHECK (paymentType IN ('Advance','Installment','Half')),
                              amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
                              status NVARCHAR(20) NOT NULL DEFAULT 'Pending' CHECK (status IN ('Pending','Completed','Failed','Refunded')),
                              paymentDate DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
                              description NVARCHAR(500),
                              createdAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
                              updatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
                              CONSTRAINT PK_payments PRIMARY KEY (paymentId),
                              CONSTRAINT FK_payments_buyers FOREIGN KEY (buyerId) REFERENCES dbo.buyers(buyerId),
                              CONSTRAINT FK_payments_sellers FOREIGN KEY (sellerId) REFERENCES dbo.sellers(sellerId),
                              CONSTRAINT FK_payments_apartments FOREIGN KEY (apartmentId) REFERENCES dbo.apartments(apartmentId),
                              CONSTRAINT FK_payments_buyerCards FOREIGN KEY (buyerCardId) REFERENCES dbo.buyerCards(buyerCardId)
);

CREATE INDEX IX_payments_date ON dbo.payments(paymentDate);
GO

-- ==============================================================
-- REVIEWS
-- ==============================================================

CREATE SEQUENCE dbo.SeqReviews AS INT START WITH 1 INCREMENT BY 1;
GO

CREATE TABLE dbo.reviews (
                             reviewId VARCHAR(10) NOT NULL DEFAULT ('R' + RIGHT('000' + CAST(NEXT VALUE FOR dbo.SeqReviews AS VARCHAR(10)), 3)),
                             buyerId VARCHAR(10) NOT NULL UNIQUE,
                             rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
                             title NVARCHAR(200) NOT NULL,
                             reviewText NVARCHAR(1000) NOT NULL,
                             isVisible BIT NOT NULL DEFAULT 1,
                             createdAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
                             updatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
                             CONSTRAINT PK_reviews PRIMARY KEY (reviewId),
                             CONSTRAINT FK_reviews_buyers FOREIGN KEY (buyerId) REFERENCES dbo.buyers(buyerId) ON DELETE CASCADE
);
GO

-- ==============================================================
-- ADMINS
-- ==============================================================

CREATE SEQUENCE dbo.SeqAdmins AS INT START WITH 1 INCREMENT BY 1;
GO

CREATE TABLE dbo.admins (
                            adminId VARCHAR(10) NOT NULL DEFAULT ('ADM' + RIGHT('000' + CAST(NEXT VALUE FOR dbo.SeqAdmins AS VARCHAR(10)), 3)),
                            username NVARCHAR(50) NOT NULL UNIQUE,
                            email NVARCHAR(100) NOT NULL UNIQUE,
                            password NVARCHAR(255) NOT NULL,
                            firstName NVARCHAR(50) NOT NULL,
                            lastName NVARCHAR(50) NOT NULL,
                            phone NVARCHAR(20),
                            isActive BIT NOT NULL DEFAULT 1,
                            createdAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
                            updatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
                            lastLogin DATETIME2 NULL,
                            CONSTRAINT PK_admins PRIMARY KEY (adminId)
);
INSERT INTO admins (username, email, password, firstName, lastName, phone)
VALUES ('admin', 'admin@apartmentx.com', 'admin123', 'System', 'Administrator', '+1-555-0123');
GO

-- ==============================================================
-- FAQS
-- ==============================================================
CREATE TABLE dbo.faqs (
                          faq_id INT IDENTITY(1,1) PRIMARY KEY,
                          question NVARCHAR(500) NOT NULL,
                          answer NVARCHAR(MAX) NOT NULL,
                          category NVARCHAR(100) DEFAULT 'General',
                          display_order INT DEFAULT 0,
                          is_active BIT DEFAULT 1,
                          created_at DATETIME2 DEFAULT GETDATE(),
                          updated_at DATETIME2 DEFAULT GETDATE()
);
CREATE INDEX IX_faqs_category ON faqs(category);
CREATE INDEX IX_faqs_active ON faqs(is_active);

-- Sample FAQs
INSERT INTO faqs (question, answer, category, display_order) VALUES

-- Registration
('How do I register as a seller?', 'Click on "Sign Up" and choose "Seller".', 'Registration', 1),
('Do I need to provide verification documents during registration?',
 'Yes, sellers are required to upload valid identification and property documents during registration for account verification and approval.',
 'Registration', 2),

-- Booking
('Can I book an apartment before making a payment?', 'No, payment is required to confirm your booking.', 'Booking', 3),
('Can I view the apartment before booking?',
 'Yes, you can schedule a visit by contacting the seller through the chat feature. Some sellers also offer virtual tours of their properties.',
 'Booking', 4),
('Can I transfer my booking to another person?',
 'No, bookings are non-transferable. Only the person who made the booking can check in or request changes through support.',
 'Booking', 5),

-- Payment
('How do payments work?', 'We accept credit/debit cards and online banking.', 'Payment', 6),
('What should I do if my payment is deducted but booking is not confirmed?',
 'If your payment is deducted but you did not receive a booking confirmation, please contact support with your transaction ID for verification and refund.',
 'Payment', 7),

-- Account
('Can I delete my account?', 'Yes, from your profile settings under "Delete Account".', 'Account', 8),
('How can I change my account password?',
 'Go to Account Settings, click on "Change Password", and follow the instructions. Make sure your new password is strong and unique.',
 'Account', 9),
('Why is my account temporarily suspended?',
 'Your account may be suspended due to policy violations or incomplete verification. Contact support to resolve the issue and regain access.',
 'Account', 10),

-- General
('Is Apartment X free to use?', 'Yes, buyers browse free; sellers pay small commission.', 'General', 11),
('Does Apartment X verify property listings?',
 'Yes, all listed properties are reviewed and verified by our team before being published to ensure authenticity and accuracy.',
 'General', 12),

-- Support
('How can I track the status of my complaint?',
 'After submitting a complaint, you can track its progress through the "My Support Tickets" section under your profile.',
 'Support', 13);
GO

