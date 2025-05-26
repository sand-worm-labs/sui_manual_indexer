/*
  Warnings:

  - You are about to drop the column `a2b` on the `CetusSwapEvent` table. All the data in the column will be lost.
  - You are about to drop the column `amountIn` on the `CetusSwapEvent` table. All the data in the column will be lost.
  - You are about to drop the column `amountOut` on the `CetusSwapEvent` table. All the data in the column will be lost.
  - Added the required column `amount_in` to the `CetusSwapEvent` table without a default value. This is not possible if the table is not empty.
  - Added the required column `amount_out` to the `CetusSwapEvent` table without a default value. This is not possible if the table is not empty.
  - Added the required column `atob` to the `CetusSwapEvent` table without a default value. This is not possible if the table is not empty.
  - Added the required column `fee_amount` to the `CetusSwapEvent` table without a default value. This is not possible if the table is not empty.

*/
-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_CetusSwapEvent" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "pool" TEXT NOT NULL,
    "amount_in" BIGINT NOT NULL,
    "amount_out" BIGINT NOT NULL,
    "atob" BOOLEAN NOT NULL,
    "fee_amount" BIGINT NOT NULL,
    "txDigest" TEXT NOT NULL,
    "eventSeq" TEXT NOT NULL
);
INSERT INTO "new_CetusSwapEvent" ("eventSeq", "id", "pool", "txDigest") SELECT "eventSeq", "id", "pool", "txDigest" FROM "CetusSwapEvent";
DROP TABLE "CetusSwapEvent";
ALTER TABLE "new_CetusSwapEvent" RENAME TO "CetusSwapEvent";
CREATE UNIQUE INDEX "CetusSwapEvent_txDigest_eventSeq_key" ON "CetusSwapEvent"("txDigest", "eventSeq");
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
