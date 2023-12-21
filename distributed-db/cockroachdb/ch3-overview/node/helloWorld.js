const CrClient = require('pg').Client //load pg client

async function main() {
  try {
    // Check parameters
    if (process.argv.length != 3) {
      console.log('Usage: node helloWorld.js CONNECTION_URI')
      process.exit(1)
    }
    // Establish a connection using the command line URI
    const connectionString = process.argv[2]
    const crClient = new CrClient(connectionString)
    await crClient.connect()

    // Issue a SELECT
    const data = await crClient.query(
      `SELECT CONCAT('Hello from CockroachDB at ', CAST (NOW() as STRING)) as hello`,
    )
    // Print out the error message
    console.log(data.rows[0].hello)
  } catch (error) {
    console.log(error.stack)
  }
  // Exit
  process.exit(0)
}

main()
