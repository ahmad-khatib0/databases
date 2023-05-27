import { randomBytes } from 'crypto';
import { client } from './client';

export const withLock = async (key: string, cb: (redisClient: Client, signals: any) => any) => {
	const retryDelayMs = 100;
	let retries = 20;
	const timeoutMs = 2000;

	const token = randomBytes(6).toString('hex');
	const lockKey = `lock:${key}`;

	while (retries >= 0) {
		retries--;
		const acquired = await client.set(lockKey, token, { NX: true, PX: timeoutMs });
		if (!acquired) {
			await pause(retryDelayMs);
			continue;
		}
		try {
			const signal = { expired: false };
			setTimeout(() => (signal.expired = true), timeoutMs);
			const proxiedClient = buildClientProxy(timeoutMs);
			const result = cb(proxiedClient, signal);
			return result;
		} finally {
			await client.unlock(lockKey, token);
		}
	}
};

//if anytime  someone uses a method on redis client we're gonna see if the lock is expired
type Client = typeof client;
const buildClientProxy = (timeoutsMs: number) => {
	const startTIme = Date.now();
	const handler = {
		get(target: Client, prop: keyof Client) {
			if (Date.now() >= startTIme + timeoutsMs) throw new Error('lock is expired ');
			const value = target[prop];
			return typeof value === 'function' ? value.bind(target) : value;
		}
	};
	return new Proxy(client, handler) as Client;
};

const pause = (duration: number) => {
	return new Promise((resolve) => {
		setTimeout(resolve, duration);
	});
};
