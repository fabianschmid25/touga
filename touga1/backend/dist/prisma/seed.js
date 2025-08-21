"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const client_1 = require("@prisma/client");
const uuid_1 = require("uuid");
const bcrypt = require("bcrypt");
const prisma = new client_1.PrismaClient();
async function main() {
    const pw1 = await bcrypt.hash('UserPass1', 10);
    const pw2 = await bcrypt.hash('UserPass2', 10);
    const pw3 = await bcrypt.hash('AdminPass123', 10);
    const pw4 = await bcrypt.hash('UserPass4', 10);
    const user1 = await prisma.user.create({
        data: {
            id: (0, uuid_1.v4)(),
            email: 'alice@example.com',
            passwordHash: pw1,
            name: 'Alice',
            role: 'USER'
        }
    });
    const user2 = await prisma.user.create({
        data: {
            id: (0, uuid_1.v4)(),
            email: 'bob@example.com',
            passwordHash: pw2,
            name: 'Bob',
            role: 'PREMIUM'
        }
    });
    const user3 = await prisma.user.create({
        data: {
            id: (0, uuid_1.v4)(),
            email: 'admin@example.com',
            passwordHash: pw3,
            name: 'Admin',
            role: 'ADMIN'
        }
    });
    const user4 = await prisma.user.create({
        data: {
            id: (0, uuid_1.v4)(),
            email: 'carol@example.com',
            passwordHash: pw4,
            name: 'Carol',
            role: 'USER'
        }
    });
    const categories = await prisma.category.createMany({
        data: [
            { id: (0, uuid_1.v4)(), name: 'Tech' },
            { id: (0, uuid_1.v4)(), name: 'Art' },
            { id: (0, uuid_1.v4)(), name: 'Science' },
        ]
    });
    const allCategories = await prisma.category.findMany();
    for (let i = 1; i <= 5; i++) {
        const author = i % 2 === 0 ? user1 : user2;
        const article = await prisma.article.create({
            data: {
                id: (0, uuid_1.v4)(),
                title: `Artikel ${i}`,
                subtitle: `Untertitel ${i}`,
                template: client_1.ArticleTemplate.STORY_4_3,
                content: `Dies ist der Inhalt von Artikel ${i}.`,
                authorId: author.id,
                viewCount: i * 10,
                categories: {
                    connect: [{ id: allCategories[i % 3].id }]
                }
            }
        });
        for (let j = 0; j < 3; j++) {
            await prisma.image.create({
                data: {
                    id: (0, uuid_1.v4)(),
                    url: `https://picsum.photos/200/300?random=${i}${j}`,
                    caption: `Bild ${j + 1} zu Artikel ${i}`,
                    order: j,
                    articleId: article.id
                }
            });
        }
        await prisma.comment.create({
            data: {
                id: (0, uuid_1.v4)(),
                content: `Kommentar zum Artikel ${i}`,
                articleId: article.id,
                authorId: user1.id
            }
        });
        await prisma.like.create({
            data: {
                id: (0, uuid_1.v4)(),
                articleId: article.id,
                userId: user2.id
            }
        });
    }
    await prisma.follow.createMany({
        data: [
            { followerId: user1.id, followingId: user2.id },
            { followerId: user1.id, followingId: user3.id },
            { followerId: user4.id, followingId: user1.id },
            { followerId: user2.id, followingId: user4.id }
        ]
    });
    await prisma.refreshToken.createMany({
        data: [
            {
                id: (0, uuid_1.v4)(),
                tokenHash: 'hashed_refresh_token_1',
                userId: user1.id,
                expiresAt: new Date(Date.now() + 1000 * 60 * 60 * 24 * 7)
            },
            {
                id: (0, uuid_1.v4)(),
                tokenHash: 'hashed_refresh_token_2',
                userId: user3.id,
                expiresAt: new Date(Date.now() + 1000 * 60 * 60 * 24 * 14)
            }
        ]
    });
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