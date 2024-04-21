const app = require("express")();
const { Client } = require("pg");
app.get("/all", async (req, res) => {
  const fromDate = new Date();

  const client = new Client({
    "host": "localhost",
    "port": 5432,
    "user": "postgres",
    "password": "postgres",
    "database": "husseindb"
  })

  //connect
  await client.connect();
  const results = await client.query("select * from employees")
  console.table(results.rows)
  //end
  client.end();

  const toDate = new Date();
  const elapsed = toDate.getTime() - fromDate.getTime();

  res.send({ "rows": results.rows, "elapsed": elapsed, "method": "old" })
})

app.listen(9000, () => console.log("Listening on port 9000"))
