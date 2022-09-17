import { client } from '$services/redis';
import { deserialize } from './deserialize';
import { itemsIndexKey } from '$services/keys';

export const searchItems = async (term: string, size: number = 5) => {
	//not alpha numeric, or spaces
	console.log(term);

	const cleaned = term
		.replace(/[^a-zA-Z0-9 ]/g, '')
		.trim()
		.split(' ')
		.map((word) => (word ? `%${word}%` : ''))
		.join(' '); // ' ' means AND ,, or \ for OR

	const query = `(@name:(${cleaned}) => { $weight: 5.0 }) | (@description:(${cleaned}))`;
	if (cleaned == '') return [];

	const results = await client.ft.search(itemsIndexKey(), query, { LIMIT: { from: 0, size } });
	return results.documents.map(({ id, value }) => deserialize(id, value as any));
	// console.log(result);
};
