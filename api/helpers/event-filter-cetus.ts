// Copyright (c) Mysten Labs, Inc.
// SPDX-License-Identifier: Apache-2.0
import { CONFIG } from "../config";
import { handleCetusEvents } from "../indexer/cetus-handler";

const cetusEventTypes = [
    "pool::AddLiquidityEvent",
    "pool::RemoveLiquidityEvent",
    "pool::CollectFeeEvent",
    "pool::FlashLoanEvent",
] as const;

export const cetusEventSubscriptions = cetusEventTypes.map((eventType) => {
    const parts = eventType.split("::");
    const isRelative = parts.length === 2;
    const packageId = isRelative ? CONFIG.CETUS_CONTRACT.packageId : parts[0];
    const module = isRelative ? parts[0] : parts[1];

    console.log(parts, module, isRelative);

    return {
        type: packageId,
        filter: {
            MoveEventModule: {
                module: "pool",
                package: packageId,
            },
        },
        callback: handleCetusEvents,
    };
});
