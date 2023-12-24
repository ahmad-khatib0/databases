let retryCount = 0
let transactionEnd = false

while (!transactionEnd) {
  if (retryCount++ >= maxRetries) {
    throw Error('Maximum retry count exceeded')
  }

  try {
    await connection.query('BEGIN TRANSACTION')
    // Check for sufficient funds
    const results = await connection.query('SELECT balance FROM accounts where id=$1', [fromId])
    const fromBalance = results.rows[0].balance
    if (fromBalance < transferAmt) {
      throw Error('Insufficient funds')
    }

    // Transfer the money
    await connection.query(`UPDATE accounts SET balance=balance-$1 WHERE id=$2`, [transferAmt, fromId])
    await connection.query(`UPDATE accounts SET balance=balance+$1 WHERE id=$2`, [transferAmt, toId])
    await connection.query('COMMIT')
    success = true
    console.log('success')
  } catch (error) {
    if (error.code == '40001') {
      // Transaction retry error
      console.log(error.code, retryCount)
      connection.query('ROLLBACK')
      // Exponential backoff
      const sleepTime = 2 ** retryCount * 100 + Math.ceil(Math.random() * 100)
      await sleep(sleepTime)
    } else {
      console.log('aborted ', error.message)
      transactionEnd = true
    }
  }
}

// a better approach by using the FOR UPDATE :
try {
  await connection.query('BEGIN TRANSACTION')
  // Check for sufficient funds (and lock row)
  const results = await connection.query(`SELECT balance FROM accounts where id=$1 FOR UPDATE`, [fromId])
  const fromBalance = results.rows[0].balance
  if (fromBalance < transferAmt) {
    throw Error('Insufficient funds')
  }
  // Lock second row
  await connection.query(`SELECT balance FROM accounts where id=$1 FOR UPDATE`, [toId])
  // Transfer the money
  await connection.query(`UPDATE accounts SET balance=balance-$1 WHERE id=$2`, [transferAmt, fromId])
  await connection.query(`UPDATE accounts SET balance=balance+$1 WHERE id=$2`, [transferAmt, toId])
  await connection.query('COMMIT')

  success = true
  console.log('success')
} catch (error) {
  console.error(error.message)
  connection.query('ROLLBACK')
  success = false
}

// By locking the ACCOUNTS rows with FOR UPDATE before actually issuing UPDATE state‐
// ments, we avoid any chance of a transaction retry being issued. However, in a pro‐
// duction implementation, it is probably advisable to include a transaction retry error
// handler in any transaction, even one that attempts to avoid a retry using FOR UPDATE
// because retry errors can still occur due to clock synchronization or other issues. For
// instance, the preceding code is vulnerable to a deadlock condition if simultaneous
// transfers between two accounts in opposite directions collide
