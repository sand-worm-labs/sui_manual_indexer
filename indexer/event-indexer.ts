import { EventId, SuiClient, SuiEvent, SuiEventFilter } from "@mysten/sui/client";
import pLimit from "p-limit";
import { CONFIG } from "../config";
import { prisma } from "../db";
import { getClient } from "../sui-utils";
import { scallopEventSubscriptions } from "../helpers/event-filter_scallop";
import { cetusEventSubscriptions } from "../helpers/event-filter-cetus";

type SuiEventsCursor = EventId | null | undefined;

type EventExecutionResult = {
	cursor: SuiEventsCursor;
	hasNextPage: boolean;
};

type EventTracker = {
	type: string;
	filter: SuiEventFilter;
	callback: (events: SuiEvent[], type: string) => any;
};

const EVENTS_TO_TRACK: EventTracker[] = [...cetusEventSubscriptions, ...scallopEventSubscriptions];

const saveLatestCursor = async (tracker: EventTracker, cursor: EventId) => {
	const data = {
		eventSeq: cursor.eventSeq,
		txDigest: cursor.txDigest,
	};

	return prisma.cursor.upsert({
		where: { id: tracker.type },
		update: data,
		create: { id: tracker.type, ...data },
	});
};

const getLatestCursor = async (tracker: EventTracker): Promise<SuiEventsCursor> => {
	const cursor = await prisma.cursor.findUnique({
		where: { id: tracker.type },
	});
	return cursor || undefined;
};

const executeEventJob = async (
	client: SuiClient,
	tracker: EventTracker,
	cursor: SuiEventsCursor,
): Promise<EventExecutionResult> => {
	try {
		const { data, hasNextPage, nextCursor } = await client.queryEvents({
			query: tracker.filter,
			cursor,
			order: "descending",
		});

		if (data.length > 0) {
			await tracker.callback(data, tracker.type);
		}

		if (nextCursor && data.length > 0) {
			await saveLatestCursor(tracker, nextCursor);
			return { cursor: nextCursor, hasNextPage };
		}
	} catch (e) {
		console.error(`[${tracker.type}] Error:`, e);
	}

	return { cursor, hasNextPage: false };
};

const runEventJob = async (client: SuiClient, tracker: EventTracker) => {
	let cursor = await getLatestCursor(tracker);
	let keepGoing = true;

	while (keepGoing) {
		const result = await executeEventJob(client, tracker, cursor);

		cursor = result.cursor;
		if (!result.hasNextPage) {
			// Wait before polling again
			await new Promise((r) => setTimeout(r, CONFIG.POLLING_INTERVAL_MS));
		}
		keepGoing = true; // Optionally: use a shutdown flag here
	}
};

export const setupListeners = async () => {
	const limit = pLimit(CONFIG.CONCURRENCY_LIMIT);
	const client = getClient(CONFIG.NETWORK);

	await Promise.all(
		EVENTS_TO_TRACK.map((tracker) =>
			limit(() => runEventJob(client, tracker)),
		),
	);
};
