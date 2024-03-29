package chapter06;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class example1 {

  public static void main(String[] args) {
    try {
      Class.forName("org.postgresql.Driver");
      String connectionURL = "jdbc:" + args[0];
      String userName = args[1];
      String passWord = args[2];

      Connection connection = DriverManager.getConnection(connectionURL, userName, passWord);
      Statement stmt = connection.createStatement();
      stmt.execute("DROP TABLE IF EXISTS names");
      stmt.execute("CREATE TABLE names (name String PRIMARY KEY NOT NULL)");
      stmt.execute("INSERT INTO names (name) VALUES('Ben'),('Jesse'),('Guy')");

      ResultSet results = stmt.executeQuery("SELECT name FROM names");
      while (results.next()) {
        System.out.println(results.getString(1));

      }
      results.close();
      stmt.close();
      connection.close();

    } catch (Exception e) {
      e.printStackTrace();
      System.exit(0);
    }
  }

}
