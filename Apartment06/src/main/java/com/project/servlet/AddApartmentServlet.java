package com.project.servlet;

import com.project.DAO.UserDAO;
import com.project.model.Apartment;
import com.project.service.ApartmentService;
import com.project.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@WebServlet("/AddApartmentServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class AddApartmentServlet extends HttpServlet {

    private ApartmentService apartmentService;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        apartmentService = new ApartmentService();
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null || session.getAttribute("userRole") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String role = String.valueOf(session.getAttribute("userRole")).toLowerCase();
        if (!"seller".equals(role)) {
            response.sendRedirect("index.jsp");
            return;
        }

        // Resolve sellerId (Sxxx) from session userId (Uxxx)
        String sellerId = request.getParameter("sellerId");
        if (sellerId == null || sellerId.trim().isEmpty()) {
            User user = (User) session.getAttribute("user");
            if (user != null) {
                sellerId = userDAO.getSellerIdByUserId(user.getUserId());
                if (sellerId != null) session.setAttribute("sellerId", sellerId);
            }
        }
        if (sellerId == null || sellerId.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Missing sellerId.");
            request.getRequestDispatcher("sellerdashboard.jsp").forward(request, response);
            return;
        }

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String postalCode = request.getParameter("postalCode");
        String contactNumber = request.getParameter("contactNumber");
        String propertyType = request.getParameter("propertyType");
        String status = request.getParameter("status");
        String priceStr = request.getParameter("price");
        String bedroomsStr = request.getParameter("bedrooms");
        String bathroomsStr = request.getParameter("bathrooms");
        String areaStr = request.getParameter("areaSqFt");
        
        // Debug logging - print all parameters
        System.out.println("AddApartmentServlet - All parameters:");
        java.util.Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();
            String paramValue = request.getParameter(paramName);
            System.out.println(paramName + ": " + paramValue);
        }
        
        System.out.println("AddApartmentServlet - Specific parameters:");
        System.out.println("title: " + title);
        System.out.println("areaSqFt parameter: " + areaStr);
        System.out.println("bedrooms: " + bedroomsStr);
        System.out.println("bathrooms: " + bathroomsStr);

        Apartment apt = new Apartment();
        apt.setSellerId(sellerId);
        apt.setTitle(title);
        apt.setDescription(description);
        apt.setAddress(address);
        apt.setCity(city);
        apt.setState(state);
        apt.setPostalCode(postalCode);
        apt.setContactNumber(contactNumber);
        apt.setPropertyType(propertyType);
        apt.setStatus(status);
        if (priceStr != null && !priceStr.trim().isEmpty()) apt.setPrice(new BigDecimal(priceStr));
        if (bedroomsStr != null && !bedroomsStr.trim().isEmpty()) apt.setBedrooms(Integer.parseInt(bedroomsStr));
        if (bathroomsStr != null && !bathroomsStr.trim().isEmpty()) apt.setBathrooms(Integer.parseInt(bathroomsStr));
        if (areaStr != null && !areaStr.trim().isEmpty()) {
            try {
                apt.setAreaSqFt(Integer.parseInt(areaStr));
                System.out.println("Set areaSqFt to: " + apt.getAreaSqFt());
            } catch (NumberFormatException e) {
                System.out.println("Error parsing areaSqFt: " + areaStr);
                e.printStackTrace();
            }
        } else {
            System.out.println("areaSqFt is null or empty");
        }

        // Save images to disk and collect web paths
        List<String> imageUrls = new ArrayList<>();
        List<Part> imageParts = new ArrayList<>();
        for (Part part : request.getParts()) {
            if ("images".equals(part.getName()) && part.getSize() > 0 && part.getContentType().startsWith("image/")) {
                imageParts.add(part);
            }
        }
        String webappRootPath = getServletContext().getRealPath("/");
        String imagesDirPath = webappRootPath + "resources/images";
        File imagesDir = new File(imagesDirPath);
        if (!imagesDir.exists()) imagesDir.mkdirs();

        for (Part imagePart : imageParts) {
            String originalFileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
            String uniqueFileName = UUID.randomUUID().toString() + "_" + originalFileName;
            String filePath = imagesDirPath + File.separator + uniqueFileName;
            imagePart.write(filePath);
            String imageUrl = "/resources/images/" + uniqueFileName;
            imageUrls.add(imageUrl);
        }

        String apartmentId = apartmentService.addApartment(apt, imageUrls);
        if (apartmentId != null) {
            response.sendRedirect("MyApartmentsServlet?message=Apartment%20added");
        } else {
            request.setAttribute("errorMessage", "Failed to add apartment.");
            request.getRequestDispatcher("sellerdashboard.jsp").forward(request, response);
        }
    }
}

