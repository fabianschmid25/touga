"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const client_1 = require("@prisma/client");
const prisma = new client_1.PrismaClient();
async function main() {
    const names = ['ForYou', 'Follow', 'Sport', 'News'];
    for (const name of names) {
        await prisma.category.upsert({
            where: { name },
            update: {},
            create: { name },
        });
    }
}
main()
    .catch(console.error)
    .finally(() => prisma.$disconnect());
//# sourceMappingURL=seed.js.map