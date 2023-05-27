import 'dotenv/config';
import { client } from '../src/services/redis';

const run = async () => {
	await client.hSet('car', {
		color: 'red',
		year: 1899
		// engine: { cylenders: 8 },
		// owner: null || "",
		// service: undefined || ""
	});

	// const car = await client.hGetAll('car');
	// if (Object.keys(car).length === 0) return console.log('car not found ');
	// console.log(car);

	await client.hSet('car1', { color: 'red', year: 1899 });
	await client.hSet('car2', { color: 'green', year: 1960 });
	await client.hSet('car3', { color: 'blue', year: 1970 });

	const commands = [1, 2, 3].map((id) => {
		return client.hGetAll(`car${id}`);
	});
	const results = await Promise.all(commands);

	console.log(results);
};
run();
