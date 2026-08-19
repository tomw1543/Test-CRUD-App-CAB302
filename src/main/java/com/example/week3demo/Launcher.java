package com.example.week3demo;

import com.example.week3demo.Database.DBController;
import com.example.week3demo.Database.Database;
import javafx.application.Application;

public class Launcher {
    public static void main(String[] args) {
        System.out.print("Checking for migrations");

        Database.migrate();
        System.out.print("Establishing connection");
        DBController DB = new DBController();


        System.out.print("trying to insert user");
        DB.create_Insert_user();
        System.out.print("created record");
        DB.close();
        Application.launch(HelloApplication.class, args);
    }
}
