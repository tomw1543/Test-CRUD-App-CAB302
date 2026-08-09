module com.example.week3demo {
    requires javafx.controls;
    requires javafx.fxml;


    opens com.example.week3demo to javafx.fxml;
    exports com.example.week3demo;
}