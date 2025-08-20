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
        data: { id: (0, uuid_1.v4)(), email: 'alice@example.com', passwordHash: pw1, name: 'Alice', role: client_1.Role.USER }
    });
    const user2 = await prisma.user.create({
        data: { id: (0, uuid_1.v4)(), email: 'bob@example.com', passwordHash: pw2, name: 'Bob', role: client_1.Role.PREMIUM }
    });
    const user3 = await prisma.user.create({
        data: { id: (0, uuid_1.v4)(), email: 'admin@example.com', passwordHash: pw3, name: 'Admin', role: client_1.Role.ADMIN }
    });
    const user4 = await prisma.user.create({
        data: { id: (0, uuid_1.v4)(), email: 'carol@example.com', passwordHash: pw4, name: 'Carol', role: client_1.Role.USER }
    });
    const tech = { id: (0, uuid_1.v4)(), name: 'Tech', slug: 'tech' };
    const art = { id: (0, uuid_1.v4)(), name: 'Art', slug: 'art' };
    const science = { id: (0, uuid_1.v4)(), name: 'Science', slug: 'science' };
    await prisma.category.createMany({ data: [tech, art, science] });
    const articlesData = [
        {
            title: 'Holistic Coaching – deine Reise zu dir selbst',
            content: '<p>Ganzheitliche Perspektiven…</p>',
            template: client_1.ArticleTemplate.FULL_9_16,
            excerpt: null,
            categories: [tech.id, art.id],
            images: ['https://picsum.photos/900/1600?random=11', 'https://picsum.photos/900/1600?random=12', 'https://picsum.photos/900/1600?random=13']
        },
        {
            title: 'Design trifft Technik – die neue Symbiose',
            content: '<p>Wie gutes Design…</p>',
            template: client_1.ArticleTemplate.CARD_3_4,
            excerpt: null,
            categories: [art.id, science.id],
            images: ['https://picsum.photos/900/1200?random=21', 'https://picsum.photos/900/1200?random=22', 'https://picsum.photos/900/1200?random=23']
        },
        {
            title: 'Kleine Experimente, große Wirkung',
            content: '<p>Iteratives Experimentieren…</p>',
            template: client_1.ArticleTemplate.STORY_4_3,
            excerpt: 'Iteratives Experimentieren führt oft schneller zu Ergebnissen…',
            categories: [tech.id, science.id],
            images: ['https://picsum.photos/1200/900?random=31', 'https://picsum.photos/1200/900?random=32', 'https://picsum.photos/1200/900?random=33']
        }
    ];
    for (const [i, data] of articlesData.entries()) {
        const articleId = (0, uuid_1.v4)();
        await prisma.article.create({
            data: {
                id: articleId,
                title: data.title,
                content: data.content,
                excerpt: data.excerpt,
                authorId: i % 2 === 0 ? user1.id : user2.id,
                template: data.template,
                publishedAt: new Date()
            }
        });
        await prisma.articleCategory.createMany({
            data: data.categories.map(catId => ({ articleId, categoryId: catId }))
        });
        for (let j = 0; j < data.images.length; j++) {
            await prisma.image.create({
                data: { id: (0, uuid_1.v4)(), articleId, url: data.images[j], caption: `Bild ${j + 1}`, order: j }
            });
        }
        await prisma.comment.create({
            data: { id: (0, uuid_1.v4)(), content: `Kommentar zu ${data.title}`, articleId, authorId: user1.id }
        });
        await prisma.like.create({
            data: { userId: user2.id, articleId }
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
            { id: (0, uuid_1.v4)(), tokenHash: 'hashed_refresh_token_1', userId: user1.id, expiresAt: new Date(Date.now() + 7 * 86400000) },
            { id: (0, uuid_1.v4)(), tokenHash: 'hashed_refresh_token_2', userId: user3.id, expiresAt: new Date(Date.now() + 14 * 86400000) }
        ]
    });
}
main()
    .catch(e => { console.error(e); process.exit(1); })
    .finally(async () => { await prisma.$disconnect(); });
//# sourceMappingURL=seed.js.map