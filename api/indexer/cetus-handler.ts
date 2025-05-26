// Copyright (c) Mysten Labs, Inc.
// SPDX-License-Identifier: Apache-2.0
import { SuiEvent } from "@mysten/sui/client";
import {
    handleAddLiquidity,
    handleCetusSwap,
    handleRemoveLiquidity,
    handleCollectFee,
    handleFlashLoan,
    AddLiquidityEvent,
    RemoveLiquidityEvent,
    CollectFeeEvent,
    FlashLoanEvent,
} from "../helpers/cetus-indexer";
import { CetusSwapEvent } from "@prisma/client";

export const handleCetusEvents = async (events: SuiEvent[], type: string) => {
    const toUpsert: Promise<any>[] = [];

    for (const event of events) {
        if (!event.type.startsWith(type)) continue;
        console.log("event", event);

        if (event.type.endsWith("::AddLiquidityEvent")) {
            await handleAddLiquidity(event, event.parsedJson as AddLiquidityEvent);
            continue;
        }

        if (event.type.endsWith("::SwapEvent")) {
            await handleCetusSwap(event, event.parsedJson as CetusSwapEvent);
            continue;
        }

        if (event.type.endsWith("::RemoveLiquidityEvent")) {
            await handleRemoveLiquidity(event, event.parsedJson as RemoveLiquidityEvent);
            continue;
        }

        if (event.type.endsWith("::CollectFeeEvent")) {
            await handleCollectFee(event, event.parsedJson as CollectFeeEvent);
            continue;
        }

        if (event.type.endsWith("::FlashLoanEvent")) {
            await handleFlashLoan(event, event.parsedJson as FlashLoanEvent);
            continue;
        }
    }

    if (toUpsert.length) await Promise.all(toUpsert);
};
