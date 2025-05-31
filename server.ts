// Copyright (c) Mysten Labs, Inc.
// SPDX-License-Identifier: Apache-2.0

import cors from "cors";
import express from "express";

import { prisma } from "./db";

const app = express();
app.use(cors());

app.use(express.json());

app.get("/", async (req, res): Promise<any> => {
    return res.send({ message: "🚀 API is functional 🚀" });
});

app.listen(3000, () => console.log(`🚀 Server ready at: http://localhost:3000`));
