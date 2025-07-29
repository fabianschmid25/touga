"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const client_1 = require("@prisma/client");
const bcrypt = require("bcrypt");
const prisma = new client_1.PrismaClient();
async function main() {
    console.log('Seeding categories...');
    const categories = ['ForYou', 'Follow', 'Sport', 'News'];
    for (const name of categories) {
        await prisma.category.upsert({
            where: { name },
            update: {},
            create: { name },
        });
    }
    console.log('Seeding users...');
    const users = [
        { email: 'user1@example.com', password: 'Password123', name: 'User One', role: client_1.Role.USER },
        { email: 'user2@example.com', password: 'Password123', name: 'User Two', role: client_1.Role.PREMIUM },
        { email: 'admin@example.com', password: 'AdminPass123', name: 'Admin User', role: client_1.Role.ADMIN },
        { email: 'a.com', password: '123', name: 'Admin User', role: client_1.Role.ADMIN },
    ];
    for (const u of users) {
        const passwordHash = await bcrypt.hash(u.password, 10);
        await prisma.user.upsert({
            where: { email: u.email },
            update: {
                name: u.name,
                role: u.role,
            },
            create: {
                email: u.email,
                passwordHash,
                name: u.name,
                role: u.role,
            },
        });
    }
    console.log('All done.');
}
main()
    .catch(e => {
    console.error(e);
    process.exit(1);
})
    .finally(async () => {
    await prisma.$disconnect();
});
//# sourceMappingURL=seed.js.map