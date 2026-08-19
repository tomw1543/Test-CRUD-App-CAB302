package com.example.week3demo.Database;


import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

public class DBController {
    private static Connection connect;
    public DBController() {
        connect = Database.DBConnect();
    }


    /*
    public void create_table(){


        try{
            Statement statement = connect.createStatement();
            statement.execute("CREATE TABLE IF NOT EXISTS testingTable (id INTEGER PRIMARY KEY, me VARCHAR, yoMoney INTEGER)");

        }catch (SQLException ex) {
            System.err.println(ex);
        }
    }

     */

    public void create_Insert_user(){
        try{
            Statement statment = connect.createStatement();
            statment.execute("INSERT INTO Users (FirstName, LastName, Email, PasswordHash, HomeLat, HomeLong, IsActive)\n" +
                    "VALUES ('Billy', 'bo', 'billy.bob@example.com', 'a1bssfe2c3asdas35g6', -29.4698, 13.0251, 1);");
        }catch (SQLException ex) {
            System.err.println(ex);
        }
    }


    public void close() {
        try{
            connect.close();
        }catch(SQLException sqlEx) {
            System.err.println(sqlEx);
        }
    }


}
