import { PrismaClient, ArticleTemplate, Role } from '@prisma/client';
import { v4 as uuidv4 } from 'uuid';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
    // Passwörter hashen
    const pw1 = await bcrypt.hash('UserPass1', 10);
    const pw2 = await bcrypt.hash('UserPass2', 10);
    const pw3 = await bcrypt.hash('AdminPass123', 10);
    const pw4 = await bcrypt.hash('UserPass4', 10);

    // Benutzer
    const user1 = await prisma.user.create({
        data: { id: uuidv4(), email: 'alice@example.com', passwordHash: pw1, name: 'Alice', role: Role.USER }
    });
    const user2 = await prisma.user.create({
        data: { id: uuidv4(), email: 'bob@example.com', passwordHash: pw2, name: 'Bob', role: Role.PREMIUM }
    });
    const user3 = await prisma.user.create({
        data: { id: uuidv4(), email: 'admin@example.com', passwordHash: pw3, name: 'Admin', role: Role.ADMIN }
    });
    const user4 = await prisma.user.create({
        data: { id: uuidv4(), email: 'carol@example.com', passwordHash: pw4, name: 'Carol', role: Role.USER }
    });

    // Kategorien
    const tech = { id: uuidv4(), name: 'Tech', slug: 'tech' };
    const art = { id: uuidv4(), name: 'Art', slug: 'art' };
    const science = { id: uuidv4(), name: 'Science', slug: 'science' };
    await prisma.category.createMany({ data: [tech, art, science] });

    // Artikel mit Templates & Multi-Kategorien
    const articlesData = [
        {
            title: 'Holistic Coaching – deine Reise zu dir selbst',
            content: '<p>Ganzheitliche Perspektiven…</p>',
            template: ArticleTemplate.FULL_9_16,
            excerpt: null,
            categories: [tech.id, art.id],
            images: ['https://picsum.photos/900/1600?random=11', 'https://picsum.photos/900/1600?random=12', 'https://picsum.photos/900/1600?random=13']
        },
        {
            title: 'Design trifft Technik – die neue Symbiose',
            content: '<p>Wie gutes Design…</p>',
            template: ArticleTemplate.CARD_3_4,
            excerpt: null,
            categories: [art.id, science.id],
            images: ['https://picsum.photos/900/1200?random=21', 'https://picsum.photos/900/1200?random=22', 'https://picsum.photos/900/1200?random=23']
        },
        {
            title: 'Kleine Experimente, große Wirkung',
            content: '<p>Iteratives Experimentieren…</p>',
            template: ArticleTemplate.STORY_4_3,
            excerpt: 'Iteratives Experimentieren führt oft schneller zu Ergebnissen…',
            categories: [tech.id, science.id],
            images: ['https://picsum.photos/1200/900?random=31', 'https://picsum.photos/1200/900?random=32', 'https://picsum.photos/1200/900?random=33']
        }
    ];

    for (const [i, data] of articlesData.entries()) {
        const articleId = uuidv4();
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
                data: { id: uuidv4(), articleId, url: data.images[j], caption: `Bild ${j + 1}`, order: j }
            });
        }
        await prisma.comment.create({
            data: { id: uuidv4(), content: `Kommentar zu ${data.title}`, articleId, authorId: user1.id }
        });
        await prisma.like.create({
            data: { userId: user2.id, articleId }
        });
    }

    // Follows
    await prisma.follow.createMany({
        data: [
            { followerId: user1.id, followingId: user2.id },
            { followerId: user1.id, followingId: user3.id },
            { followerId: user4.id, followingId: user1.id },
            { followerId: user2.id, followingId: user4.id }
        ]
    });

    // Refresh Tokens
    await prisma.refreshToken.createMany({
        data: [
            { id: uuidv4(), tokenHash: 'hashed_refresh_token_1', userId: user1.id, expiresAt: new Date(Date.now() + 7 * 86400000) },
            { id: uuidv4(), tokenHash: 'hashed_refresh_token_2', userId: user3.id, expiresAt: new Date(Date.now() + 14 * 86400000) }
        ]
    });
}

main()
    .catch(e => { console.error(e); process.exit(1); })
    .finally(async () => { await prisma.$disconnect(); });
