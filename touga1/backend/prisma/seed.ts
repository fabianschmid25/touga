import { PrismaClient } from '@prisma/client';
const prisma = new PrismaClient();

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