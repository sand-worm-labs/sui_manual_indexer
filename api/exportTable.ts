import { PrismaClient } from "@prisma/client";
import { writeFileSync } from "fs";
import { Parser } from "json2csv";

const prisma = new PrismaClient();

async function main() {
    // change this to the table you want to export!
    const data = await prisma.cetusEvent.findMany(); // ← change `moutai` to your actual model

    if (!data.length) {
        console.log("No data found in the table 😢");
        return;
    }

    const parser = new Parser();
    const csv = parser.parse(data);

    writeFileSync("export.csv", csv);
    console.log("Export complete ✅ File saved as export.csv");
}

main()
    .catch((e) => {
        console.error("❌ Error exporting table:", e);
    })
    .finally(async () => {
        await prisma.$disconnect();
    });
