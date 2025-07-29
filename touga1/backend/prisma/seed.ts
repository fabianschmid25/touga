import { PrismaClient, Role } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
    // Seed categories
    console.log('Seeding categories...');
    const categories = ['ForYou', 'Follow', 'Sport', 'News'];
    for (const name of categories) {
        await prisma.category.upsert({
            where: { name },
            update: {},
            create: { name },
        });
    }

    // Seed users
    console.log('Seeding users...');
    const users = [
        { email: 'user1@example.com', password: 'Password123', name: 'User One', role: Role.USER },
        { email: 'user2@example.com', password: 'Password123', name: 'User Two', role: Role.PREMIUM },
        { email: 'admin@example.com', password: 'AdminPass123', name: 'Admin User', role: Role.ADMIN },
        { email: 'a.com', password: '123', name: 'Admin User', role: Role.ADMIN },
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