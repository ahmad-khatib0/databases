/* 
  analyse the output from the hotranges dump 
*/

const fs = require('fs')

// the following JavaScript code will take the output of /status/_hotranges
// and print the top 10 ranges in the cluster:
async function main() {
  const unsortedRanges = []
  let ranges = fs.readFileSync('hotranges.json', 'utf8')
  let rangeJson = JSON.parse(ranges)

  Object.keys(rangeJson.hotRangesByNodeId).forEach((node) => {
    let hotRanges = rangeJson.hotRangesByNodeId[node]
    hotRanges.stores.forEach((store) => {
      store.hotRanges.forEach((range) => {
        unsortedRanges.push({
          node,
          storeId: store.storeId,
          rangeId: range.desc.rangeId,
          queriesPerSecond: range.queriesPerSecond,
        })
      })
    })
  })

  unsortedRanges.sort((a, b) => (a.queriesPerSecond > b.queriesPerSecond && -1) || 1)
  for (let ic = 0; ic < 10; ic++) console.log(unsortedRanges[ic])
}

main()

// Alternatively, you can use the cockroach debug zip command to extract a full diagnostic debug
// file. Inside that file, the script hot-ranges.sh will print out the hottest ranges on the cluster:
// $ cockroach debug zip cockroachDebug.zip --host=mbp1.local --certs-dir=cockroach/certs
// $ /tmp unzip cockroachDebug.zip
// $ /tmp cd debug
// $ debug bash hot-ranges.sh
//
// Once we’ve found the hot ranges, we can look at the crdb_internal.ranges
// table to see what tables and keys are associated with the range:
// defaultdb> \set display_format=records
//
// SELECT
//   table_name,
//   start_pretty,
//   end_pretty ,
//   replicas,
//   lease_holder,
//   round(range_size / 1048576) mb
// FROM crdb_internal.ranges
// WHERE range_id = 230;
