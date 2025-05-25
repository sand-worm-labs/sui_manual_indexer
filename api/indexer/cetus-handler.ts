// Copyright (c) Mysten Labs, Inc.
// SPDX-License-Identifier: Apache-2.0
import { SuiEvent } from "@mysten/sui/client";
import { prisma } from "../db";

type CetusSwapEvent = {
    pool: string;
    a2b: boolean;
    amount_in: string;
    amount_out: string;
    fee_amount: string;
};

type AddLiquidityEvent = {
    pool: string;
    position: string;
    tick_lower: number;
    tick_upper: number;
    liquidity: string;
    amount_a: string;
    amount_b: string;
};

type RemoveLiquidityEvent = AddLiquidityEvent;

type CollectFeeEvent = {
    position: string;
    pool: string;
    amount_a: string;
    amount_b: string;
};

type FlashLoanEvent = {
    pool: string;
    loan_a: boolean;
    partner: string;
    amount: string;
    fee_amount: string;
};

export const handleCetusEvents = async (events: SuiEvent[], type: string) => {
    const toUpsert: Promise<any>[] = [];

    for (const event of events) {
        console.log("event type:", event.type);
        if (!event.type.startsWith(type)) continue;

        const { txDigest, eventSeq } = event.id;

        // 🌀 SWAP
        if (event.type.endsWith("::CetusSwapEvent")) {
            const data = event.parsedJson as CetusSwapEvent;

            toUpsert.push(
                prisma.cetusSwapEvent.upsert({
                    where: {
                        cetusSwap_txDigest_eventSeq: { txDigest, eventSeq },
                    },
                    update: {},
                    create: {
                        pool: data.pool,
                        a2b: data.a2b,
                        amountIn: BigInt(data.amount_in),
                        amountOut: BigInt(data.amount_out),
                        txDigest,
                        eventSeq,
                    },
                }),
            );
            continue;
        }

        // 🧪 ADD LIQ
        if (event.type.endsWith("::AddLiquidityEvent")) {
            const data = event.parsedJson as AddLiquidityEvent;

            toUpsert.push(
                prisma.cetusAddLiquidityEvent.upsert({
                    where: {
                        cetusAddLiquidity_txDigest_eventSeq: { txDigest, eventSeq },
                    },
                    update: {},
                    create: {
                        pool: data.pool,
                        position: data.position,
                        tickLower: data.tick_lower,
                        tickUpper: data.tick_upper,
                        liquidity: BigInt(data.liquidity),
                        amountA: BigInt(data.amount_a),
                        amountB: BigInt(data.amount_b),
                        txDigest,
                        eventSeq,
                    },
                }),
            );
            continue;
        }

        // 🧯 REMOVE LIQ
        if (event.type.endsWith("::RemoveLiquidityEvent")) {
            const data = event.parsedJson as RemoveLiquidityEvent;

            toUpsert.push(
                prisma.cetusRemoveLiquidityEvent.upsert({
                    where: {
                        cetusRemoveLiquidity_txDigest_eventSeq: { txDigest, eventSeq },
                    },
                    update: {},
                    create: {
                        pool: data.pool,
                        position: data.position,
                        tickLower: data.tick_lower,
                        tickUpper: data.tick_upper,
                        liquidity: BigInt(data.liquidity),
                        amountA: BigInt(data.amount_a),
                        amountB: BigInt(data.amount_b),
                        txDigest,
                        eventSeq,
                    },
                }),
            );
            continue;
        }

        // 💰 COLLECT FEE
        if (event.type.endsWith("::CollectFeeEvent")) {
            const data = event.parsedJson as CollectFeeEvent;

            toUpsert.push(
                prisma.cetusCollectFeeEvent.upsert({
                    where: {
                        cetusCollectFee_txDigest_eventSeq: { txDigest, eventSeq },
                    },
                    update: {},
                    create: {
                        pool: data.pool,
                        position: data.position,
                        amountA: BigInt(data.amount_a),
                        amountB: BigInt(data.amount_b),
                        txDigest,
                        eventSeq,
                    },
                }),
            );
            continue;
        }

        // ⚡ FLASH LOAN
        if (event.type.endsWith("::FlashLoanEvent")) {
            const data = event.parsedJson as FlashLoanEvent;

            toUpsert.push(
                prisma.cetusFlashLoanEvent.upsert({
                    where: {
                        cetusFlashLoan_txDigest_eventSeq: { txDigest, eventSeq },
                    },
                    update: {},
                    create: {
                        pool: data.pool,
                        loanA: data.loan_a,
                        partner: data.partner,
                        amount: BigInt(data.amount),
                        feeAmount: BigInt(data.fee_amount),
                        txDigest,
                        eventSeq,
                    },
                }),
            );
            continue;
        }
    }

    if (toUpsert.length) await Promise.all(toUpsert);
};
