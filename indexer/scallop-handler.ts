// Copyright (c) Mysten Labs, Inc.
// SPDX-License-Identifier: Apache-2.0
import { SuiEvent } from "@mysten/sui/client";
import {
    handleScallopBorrowDynamic,
    handleCollateralDeposit,
    handleCollateralWithdraw,
    handleObligationCreated,
    handleScallopMint,
    ScallopBorrowDynamicEvent,
    ScallopDepositEvent,
    ScallopWithdrawEvent,
    ScallopObligationCreatedEvent,
    ScallopMintEvent,
    handleScallopRedeem,
    ScallopRedeemEvent,
} from "../helpers/scallop_indexer";

export const handleScallopEvents = async (events: SuiEvent[], type: string) => {
    const toUpsert: Promise<any>[] = [];

    for (const event of events) {
        if (!event.type.startsWith(type)) continue;

        // const { txDigest, eventSeq } = event.id;

        if (event.type.endsWith("::BorrowDynamic")) {
            handleScallopBorrowDynamic(event.parsedJson as ScallopBorrowDynamicEvent);
        }

        if (event.type.endsWith("::deposit_collateral::CollateralDepositEvent")) {
            handleCollateralDeposit(event, event.parsedJson as ScallopDepositEvent);
        }

        if (event.type.endsWith("::withdraw_collateral::CollateralWithdrawEvent")) {
            handleCollateralWithdraw(event, event.parsedJson as ScallopWithdrawEvent);
        }

        if (event.type.endsWith("::open_obligation::ObligationCreatedEvent")) {
            handleObligationCreated(event, event.parsedJson as ScallopObligationCreatedEvent);
        }

        if (event.type.endsWith("::mint::MintEvent")) {
            handleScallopMint(event, event.parsedJson as ScallopMintEvent);
        }

        if (event.type.endsWith("::redeem::RedeemEvent")) {
            handleScallopRedeem(event, event.parsedJson as ScallopRedeemEvent);
        }
    }

    if (toUpsert.length) await Promise.all(toUpsert);
};
