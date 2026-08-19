package com.example.week3demo.Database;

import org.flywaydb.core.Flyway;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;


public class Database {
    public static Connection instance = null;
    private static final String connection_path = "jdbc:sqlite:database.db";
    private Database() {
        try {


            instance = DriverManager.getConnection(connection_path);

                try (Statement stmt = instance.createStatement()) {
                    stmt.execute("PRAGMA foreign_keys = ON;");
                    stmt.execute("PRAGMA journal_mode = WAL;");
                }


        }catch (SQLException sqlEx) {
            throw new RuntimeException("Failed to connect to database", sqlEx);
        }



        }

    public static void migrate() {
        Flyway.configure()
                .dataSource(connection_path, null, null)
                .load()
                .migrate();
    }

        public static Connection DBConnect(){
        if(instance == null){

            new Database();


        }
        return instance;
        }
    }

