module com.example.week3demo {
    requires javafx.controls;
    requires javafx.fxml;
    requires java.sql;
    requires flyway.core;


    opens com.example.week3demo to javafx.fxml;
    exports com.example.week3demo;
    exports com.example.week3demo.Database;
    opens com.example.week3demo.Database to javafx.fxml;
    opens db.migration to flyway.core;
}