// Copyright (c) Mysten Labs, Inc.
// SPDX-License-Identifier: Apache-2.0

import { execSync } from "child_process";
import { readFileSync, writeFileSync } from "fs";
import { homedir } from "os";
import path from "path";
import { getFullnodeUrl, SuiClient } from "@mysten/sui/client";
import { Ed25519Keypair } from "@mysten/sui/keypairs/ed25519";
import { Transaction } from "@mysten/sui/transactions";
import { fromBase64 } from "@mysten/sui/utils";

export type Network = "mainnet" | "testnet" | "devnet" | "localnet";

export const ACTIVE_NETWORK = (process.env.NETWORK as Network) || "testnet";

export const SUI_BIN = `sui`;

export const getActiveAddress = () => {
    return execSync(`${SUI_BIN} client active-address`, { encoding: "utf8" }).trim();
};


/** Get the client for the specified network. */
export const getClient = (network: Network) => {
    const url = process.env.SUI_RPC_URL || getFullnodeUrl(network);
    return new SuiClient({ url });
};