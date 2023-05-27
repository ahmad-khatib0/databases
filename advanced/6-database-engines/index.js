// create table employees_myisam (id int primary key auto_increment , name text ) engine myisam ;
// show engines   # show what engines your db support

const mysql = require("mysql2/promise");

connectInnoDB();

// with Innodb it dose  support transactions
async function connectInnoDB() {
  try {
    const con = await mysql.createConnection({
      host: "localhost",
      port: 3306,
      user: "root",
      password: "password",
      database: "test",
    });
    await con.beginTransaction();
    await con.query("INSERT INTO employees_innodb (name) values (?)", [
      "Ahamd",
    ]);

    const [rows, schema] = await con.query("select * from employees_innodb");
    console.table(rows);
    // you can see your changes in this reserved lock, but other unable to see until you commit

    await con.commit();
    await con.close();
    console.log(result);
  } catch (ex) {
    console.error(ex);
  } finally {
  }
}

// with MYISAM it dose not support transactions
async function connectMyISAM() {
  try {
    const con = await mysql.createConnection({
      host: "localhost",
      port: 3306,
      user: "root",
      password: "password",
      database: "test",
    });
    await con.beginTransaction();
    await con.query("INSERT INTO employees_myisam (name) values (?)", [
      "Ahmad",
    ]);

    await con.commit();
    await con.close();
    console.log(result);
  } catch (ex) {
    console.error(ex);
  } finally {
  }
}
