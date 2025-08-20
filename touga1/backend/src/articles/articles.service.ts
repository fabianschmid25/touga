// src/articles/articles.service.ts
import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateArticleDto } from './dto/create-article.dto';
import { Article, Prisma } from '@prisma/client';

@Injectable()
export class ArticlesService {
    constructor(private readonly prisma: PrismaService) { }

    /** Alle Artikel (ohne gelöschte) inklusive Bilder & Kategorien laden */
    /** Leichtgewichtiger Feed: nur Felder, die der Feed braucht */
    async findAll() {
        const articles = await this.prisma.article.findMany({
            where: { deletedAt: null },
            orderBy: { createdAt: 'desc' },
            include: {
                images: { where: { deletedAt: null } },
                categories: {
                    include: { category: true }, // explizite Join-Tabelle -> echte Category holen
                },
            },
        });

        // Map auf schlankes Feed-DTO
        return articles.map(a => ({
            id: a.id,
            title: a.title,
            template: a.template ?? null,
            excerpt: a.excerpt ?? null,
            categories: a.categories
                .map(ac => ac.category)
                .filter(c => !c.deletedAt)
                .map(c => ({ id: c.id, name: c.name })),
            coverUrl: a.images.find(img => img.order === 0 && !img.deletedAt)?.url ?? null,
            createdAt: a.createdAt,
        }));
    }


    /** Einzelnen Artikel (inkl. Bilder & Kategorien) laden */
    /** Einzelnen Artikel inkl. Kategorien & Bilder laden (Detailansicht) */
    async findOne(id: string) {
        const article = await this.prisma.article.findUnique({
            where: { id },
            include: {
                images: { where: { deletedAt: null }, orderBy: { order: 'asc' } },
                categories: { include: { category: true } },
                author: true,
            },
        });

        if (!article || article.deletedAt) {
            throw new NotFoundException(`Article ${id} not found`);
        }

        return {
            id: article.id,
            title: article.title,
            content: article.content,
            excerpt: article.excerpt,
            template: article.template ?? null,
            categories: article.categories
                .map(ac => ac.category)
                .filter(c => !c.deletedAt)
                .map(c => ({ id: c.id, name: c.name })),
            images: article.images.map(img => ({ id: img.id, url: img.url, caption: img.caption, order: img.order })),
            author: article.author ? { id: article.author.id, name: article.author.name, avatarUrl: article.author.avatarUrl } : null,
            publishedAt: article.publishedAt,
            createdAt: article.createdAt,
        };
    }


    /** Artikel anlegen inkl. Bilder & m:n Kategorien */
    async create(dto: CreateArticleDto, authorId: string) {
        const { title, content, excerpt, template, imageUrls, categoryIds } = dto;

        const article = await this.prisma.article.create({
            data: {
                title,
                content: content ?? null,
                excerpt: excerpt ?? null,
                template: template ?? null,
                authorId,
                publishedAt: new Date(),
                images: {
                    create: (imageUrls ?? []).map((url, index) => ({
                        url,
                        order: index,
                    })),
                },
                ...(categoryIds?.length
                    ? {
                        categories: {
                            createMany: {
                                data: categoryIds.map((categoryId) => ({ categoryId })),
                                skipDuplicates: true,
                            },
                        },
                    }
                    : {}),
            },
            include: {
                images: true,
                categories: { include: { category: true } },
            },
        });

        return {
            id: article.id,
            title: article.title,
            template: article.template,
            excerpt: article.excerpt,
            categories: article.categories.map(ac => ({ id: ac.category.id, name: ac.category.name })),
            coverUrl: article.images.find(i => i.order === 0)?.url ?? null,
        };
    }


    /** Soft‑Delete: deletedAt setzen */
    async remove(id: string): Promise<void> {
        await this.prisma.article.update({
            where: { id },
            data: { deletedAt: new Date() },
        });
    }
}
