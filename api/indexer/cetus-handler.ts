// Copyright (c) Mysten Labs, Inc.
// SPDX-License-Identifier: Apache-2.0
import { SuiEvent } from "@mysten/sui/client";
import { prisma } from "../db";

type RawCetusSwapEvent = {
    pool: string;
    amount_in: string;
    amount_out: string;
    a2b: boolean;
    by_amount_in: boolean;
};

export const handleCetusEvents = async (events: SuiEvent[], type: string) => {
    const toUpsert = [];

    for (const event of events) {
        if (!event.type.startsWith(type)) continue;
        if (!event.type.endsWith("::CetusSwapEvent")) continue;

        const data = event.parsedJson as RawCetusSwapEvent;

        toUpsert.push(
            prisma.cetusEvent.upsert({
                where: {
                    txDigest_eventSeq: {
                        txDigest: event.id.txDigest,
                        eventSeq: event.id.eventSeq,
                    },
                },
                update: {},
                create: {
                    pool: data.pool,
                    amountIn: BigInt(data.amount_in),
                    amountOut: BigInt(data.amount_out),
                    a2b: data.a2b,
                    byAmountIn: data.by_amount_in,
                    txDigest: event.id.txDigest,
                    eventSeq: event.id.eventSeq,
                },
            }),
        );
    }

    if (toUpsert.length) {
        await Promise.all(toUpsert);
    }
};
