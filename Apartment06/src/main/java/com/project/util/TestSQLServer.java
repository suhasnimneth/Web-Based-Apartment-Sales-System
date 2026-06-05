package com.project.util;

import java.sql.Connection;
import java.sql.DriverManager;
public class TestSQLServer {
    public static void main(String[] args)
    {
        String url = "jdbc:sqlserver://localhost:1433;databaseName=Apartment_06;encrypt=true;trustServerCertificate=true";
        String user = "sa";
        String password = "12";
        try (Connection conn = DriverManager.getConnection(url, user, password))
        {
            System.out.println("✅ Successfully connected to the database.");
        } catch (Exception e)
        {
            System.out.println("❌ Failed to connect to the database.");
        }
    }
}
