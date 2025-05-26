// Copyright (c) Mysten Labs, Inc.
// SPDX-License-Identifier: Apache-2.0
import { prisma } from "../db";
import type { SuiEvent } from "@mysten/sui/client";

export type CetusSwapEvent = {
    id: string;
    eventSeq: string;
    txDigest: string;
    pool: string;
    amount_in: bigint;
    amount_out: bigint;
    atob: boolean;
    fee_amount: bigint;
    sender: string;
    timestampMs: bigint;
};

export type AddLiquidityEvent = {
    pool: string;
    position: string;
    tick_lower: { bits: number };
    tick_upper: { bits: number };
    liquidity: string; // Changed from bigint to string since it comes as string from the event
    amount_a: string;
    amount_b: string;
    after_liquidity: string;
};

export type RemoveLiquidityEvent = AddLiquidityEvent;

export type CollectFeeEvent = {
    position: string;
    pool: string;
    amount_a: string;
    amount_b: string;
    sender: string;
    timestampMs: bigint;
};

export type FlashLoanEvent = {
    pool: string;
    loan_a: boolean;
    partner: string;
    amount: string;
    fee_amount: string;
};

export const handleAddLiquidity = async (event: SuiEvent, data: AddLiquidityEvent) => {
   

    const { txDigest, eventSeq } = event.id;
    return prisma.cetusAddLiquidityEvent.upsert({
        where: { cetusAddLiquidity_txDigest_eventSeq: { txDigest, eventSeq } },
        update: {},
        create: {
            pool: data.pool,
            position: data.position,
            tickLower: BigInt((data.tick_lower as any).bits),
            tickUpper: BigInt((data.tick_upper as any).bits),
            liquidity: BigInt(data.liquidity).toString(),
            amountA: BigInt(data.amount_a),
            amountB: BigInt(data.amount_b),
            txDigest,
            eventSeq,
            sender: event.sender,
            timestampMs: BigInt(event.timestampMs),
        },
    });
};

export const handleCetusSwap = async (event: SuiEvent, data: CetusSwapEvent) => {
    const { txDigest, eventSeq } = event.id;
    return prisma.cetusSwapEvent.upsert({
        where: { cetusSwap_txDigest_eventSeq: { txDigest, eventSeq } },
        update: {},
        create: {
            pool: data.pool,
            atob: data.atob,
            fee_amount: BigInt(data.fee_amount),
            amount_in: BigInt(data.amount_in),
            amount_out: BigInt(data.amount_out),
            txDigest,
            eventSeq,
            sender: event.sender,
            timestampMs: Number(event.timestampMs),
        },
    });
};

export const handleRemoveLiquidity = async (event: SuiEvent, data: RemoveLiquidityEvent) => {

    const { txDigest, eventSeq } = event.id;
    return prisma.cetusRemoveLiquidityEvent.upsert({
        where: { cetusRemoveLiquidity_txDigest_eventSeq: { txDigest, eventSeq } },
        update: {},
        create: {
            pool: data.pool,
            position: data.position,
            tickLower: (data.tick_lower as any).bits,
            tickUpper: (data.tick_upper as any).bits,
            liquidity: BigInt(data.liquidity).toString(),
            amountA: BigInt(data.amount_a),
            amountB: BigInt(data.amount_b),
            txDigest,
            eventSeq,
            sender: event.sender,
            timestampMs: Number(event.timestampMs),
        },
    });
};

export const handleCollectFee = async (event: SuiEvent, data: CollectFeeEvent) => {
    const { txDigest, eventSeq } = event.id;
    return prisma.cetusCollectFeeEvent.upsert({
        where: { cetusCollectFee_txDigest_eventSeq: { txDigest, eventSeq } },
        update: {},
        create: {
            pool: data.pool,
            position: data.position,
            amountA: BigInt(data.amount_a),
            amountB: BigInt(data.amount_b),
            txDigest,
            eventSeq,
            sender: event.sender,
            timestampMs: Number(event.timestampMs),
        },
    });
};

export const handleFlashLoan = async (event: SuiEvent, data: FlashLoanEvent) => {
    const { txDigest, eventSeq } = event.id;
    return prisma.cetusFlashLoanEvent.upsert({
        where: { cetusFlashLoan_txDigest_eventSeq: { txDigest, eventSeq } },
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
    });
};
