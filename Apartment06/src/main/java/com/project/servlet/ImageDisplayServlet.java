package com.project.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

@WebServlet("/image")
public class ImageDisplayServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get the image filename from the request parameter
        String filename = request.getParameter("file");
        if (filename == null || filename.isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        // Construct the full file path
        String webappRootPath = getServletContext().getRealPath("/");
        String fullImagePath = webappRootPath + "resources/images/" + filename;
        
        File imageFile = new File(fullImagePath);
        
        if (!imageFile.exists() || !imageFile.isFile()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        // Set content type based on file extension
        String fileName = imageFile.getName().toLowerCase();
        if (fileName.endsWith(".jpg") || fileName.endsWith(".jpeg")) {
            response.setContentType("image/jpeg");
        } else if (fileName.endsWith(".png")) {
            response.setContentType("image/png");
        } else if (fileName.endsWith(".gif")) {
            response.setContentType("image/gif");
        } else {
            response.setContentType("application/octet-stream");
        }
        
        // Set content length
        response.setContentLength((int) imageFile.length());
        
        // Write the image to the response
        try (FileInputStream fis = new FileInputStream(imageFile);
             OutputStream os = response.getOutputStream()) {
            
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = fis.read(buffer)) != -1) {
                os.write(buffer, 0, bytesRead);
            }
        }
    }
}
