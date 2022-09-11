import { client } from '$services/redis';
import { itemsByViewsKey, itemsKey } from '$services/keys';
import { deserialize } from './deserialize';

export const itemsByViews = async (order: 'DESC' | 'ASC' = 'DESC', offset = 0, count = 10) => {
	let results: any = await client.sort(itemsByViewsKey(), {
		GET: [
			'#',
			`${itemsKey('*')}->name`,
			`${itemsKey('*')}->views`,
			`${itemsKey('*')}->endingAt`,
			`${itemsKey('*')}->imageUrl`,
			`${itemsKey('*')}->price`
		], //# refers to the id
		BY: 'score', //or nosort, score is not a member name in items, items are already sorted set
		//so its more efficient to not sort it again
		DIRECTION: order,
		LIMIT: { offset, count }
	});

	// console.log(results);
	//chunk off the id,name,views to an array of object items
	const items = [];
	while (results.length) {
		const [id, name, views, endingAt, imageUrl, price, ...rest] = results;
		const item = deserialize(id, { name, views, endingAt, imageUrl, price });
		items.push(item);
		results = rest;
	}
	return items;
};
