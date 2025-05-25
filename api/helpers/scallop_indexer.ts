// Copyright (c) Mysten Labs, Inc.
// SPDX-License-Identifier: Apache-2.0

import { SuiEvent } from "@mysten/sui/client";
import { prisma } from "../db";

export type ScallopBorrowDynamicEvent = {
    coin_type: string;
    borrow_index: string;
    interest_rate: string;
    interest_rate_scale: string;
    last_updated: string;
};

export type ScallopDepositEvent = {
    deposit_amount: string;
    deposit_asset: { name: string };
    obligation: string;
    provider: string;
};

export type ScallopWithdrawEvent = {
    provider: any;
    withdraw_asset?: { name: string };
    withdraw_amount?: string;
    timestampMs?: string;
    obligation: string;
    taker: string;
};

export type ScallopObligationCreatedEvent = {
    obligation: string;
    obligation_key: string;
    sender: string;
    version: string;
    timestampMs: string;
};

export type ScallopMintEvent = {
    sender: string;
    timestampMs: string;
    deposit_asset: { name: string };
    deposit_amount: string;
    mint_asset: { name: string };
    mint_amount: string;
    minter: string;
    time: string;
};

export type ScallopRedeemEvent = {
    withdraw_asset: {
        name: string;
    };
    withdraw_amount: string;
    burn_asset: {
        name: string;
    };
    burn_amount: string;
    redeemer: string;
    time: string;
};

export const handleScallopBorrowDynamic = (data: ScallopBorrowDynamicEvent) => {
    return prisma.scallopBorrowDynamic.upsert({
        where: { coinType: data.coin_type },
        update: {
            borrowIndex: data.borrow_index,
            interestRate: data.interest_rate,
            interestRateScale: data.interest_rate_scale,
            lastUpdated: data.last_updated,
        },
        create: {
            coinType: data.coin_type,
            borrowIndex: data.borrow_index,
            interestRate: data.interest_rate,
            interestRateScale: data.interest_rate_scale,
            lastUpdated: data.last_updated,
        },
    });
};

export const handleCollateralDeposit = async (event: SuiEvent, data: ScallopDepositEvent) => {
    const obligation_id = data.obligation;
    const timestampMs = event.timestampMs?.toString() || Date.now().toString();

    await prisma.scallopObligation.upsert({
        where: { obligation_id },
        update: { updatedAt: new Date() },
        create: {
            obligation_id,
            sender: data.provider,
            timestampMs,
        },
    });

    return prisma.scallopDeposit.create({
        data: {
            asset: data.deposit_asset.name,
            amount: data.deposit_amount,
            timestampMs,
            obligation: { connect: { obligation_id } },
        },
    });
};

export const handleCollateralWithdraw = async (event: SuiEvent, data: ScallopWithdrawEvent) => {
    const timestampMs = event.timestampMs?.toString() || Date.now().toString();
    await prisma.scallopObligation.upsert({
        where: { obligation_id: data.obligation },
        update: { updatedAt: new Date() },
        create: {
            obligation_id: data.obligation,
            sender: data.provider,
            timestampMs,
        },
    });

    return prisma.scallopWithdraw.create({
        data: {
            asset: data.withdraw_asset.name,
            amount: data.withdraw_amount,
            timestampMs,
            obligation: { connect: { obligation_id: data.obligation } },
            taker: data.taker,
        },
    });
};

export const handleObligationCreated = async (
    event: SuiEvent,
    data: ScallopObligationCreatedEvent,
) => {
    const timestampMs = event.timestampMs?.toString() || Date.now().toString();

    if (!data.obligation) {
        console.error("Missing obligation_id. Event data:", data);
        return;
    }

    const existingObligation = await prisma.scallopObligation.findUnique({
        where: { obligation_id: data.obligation },
    });

    if (existingObligation) {
        const updateFields: any = {
            updatedAt: new Date(),
        };

        if (!existingObligation.sender?.trim() && data.sender) {
            updateFields.sender = data.sender;
        }

        if (!existingObligation.obligation_key?.trim() && data.obligation_key) {
            updateFields.obligation_key = data.obligation_key;
        }

        if (!existingObligation.version && data.version) {
            updateFields.version = data.version;
        }

        if (!existingObligation.timestampMs && timestampMs) {
            updateFields.timestampMs = timestampMs;
        }

        return prisma.scallopObligation.update({
            where: { obligation_id: data.obligation },
            data: updateFields,
        });
    } else {
        console.warn("obligation_id is undefined in this event, skipping...");
    }

    // Create fresh if it doesn't exist
    return prisma.scallopObligation.upsert({
        where: { obligation_id: data.obligation },
        update: {
            sender: data.sender,
            obligation_key: data.obligation_key,
            version: data.version,
            timestampMs,
        },
        create: {
            obligation_id: data.obligation,
            sender: data.sender,
            obligation_key: data.obligation_key,
            version: data.version,
            timestampMs,
        },
    });
};

export const handleScallopMint = async (event: SuiEvent, data: ScallopMintEvent) => {
    const timestampMs = event.timestampMs?.toString() || Date.now().toString();

    return prisma.scallopMint.create({
        data: {
            depositAsset: data.deposit_asset.name,
            depositAmount: data.deposit_amount,
            mintAsset: data.mint_asset.name,
            mintAmount: data.mint_amount,
            minter: data.minter,
            mintTime: data.time,
            timestampMs,
        },
    });
};

export const handleScallopRedeem = async (event: SuiEvent, data: ScallopRedeemEvent) => {
    const timestampMs = event.timestampMs?.toString() || Date.now().toString();
    const sender = event.sender;

    return prisma.scallopRedeem.create({
        data: {
            sender,
            withdrawAsset: data.withdraw_asset.name,
            withdrawAmount: data.withdraw_amount,
            burnAsset: data.burn_asset.name,
            burnAmount: data.burn_amount,
            redeemer: data.redeemer,
            redeemTime: data.time,
            timestampMs,
        },
    });
};
