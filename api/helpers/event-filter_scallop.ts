// Copyright (c) Mysten Labs, Inc.
// SPDX-License-Identifier: Apache-2.0
import { CONFIG } from "../config";
import { handleScallopEvents } from "../indexer/scallop-handler";

export const scallopEventTypes = [
    "::open_obligation::ObligationCreatedEvent",
    "::deposit_collateral::CollateralDepositEvent",
    "::withdraw_collateral::CollateralWithdrawEvent",
    "::repay::RepayEvent",
    "::liquidate::LiquidateEvent",
    "::flash_loan::BorrowFlashLoanEvent",
    "::flash_loan::RepayFlashLoanEvent",
    "::mint::MintEvent",
    "::redeem::RedeemEvent",
    "::borrow::BorrowEvent",
    "0xc38f849e81cfe46d4e4320f508ea7dda42934a329d5a6571bb4c3cb6ea63f5da::borrow::BorrowEventV2",
    "0x6e641f0dca8aedab3101d047e96439178f16301bf0b57fe8745086ff1195eb3e::borrow::BorrowEventV3",
] as const;

export const scallopEventSubscriptions = scallopEventTypes.map((eventType) => {
    const parts = eventType.split("::");
    const isRelative = parts.length === 3;
    const [maybePackage, module, _eventName] = parts;
    const packageId = isRelative ? CONFIG.SCALLOP_CONTRACT.packageId : maybePackage;

    return {
        type: packageId,
        filter: {
            MoveEventModule: {
                module,
                package: packageId,
            },
        },
        callback: handleScallopEvents,
    };
});
