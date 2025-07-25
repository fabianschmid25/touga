// src/articles/articles.service.ts
import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateArticleDto } from './dto/create-article.dto';
import { Article, Prisma } from '@prisma/client';

@Injectable()
export class ArticlesService {
    constructor(private readonly prisma: PrismaService) { }

    /** Alle Artikel (ohne gelöschte) inklusive Bilder & Kategorien laden */
    async findAll(): Promise<Article[]> {
        return this.prisma.article.findMany({
            where: { deletedAt: null },
            include: {
                images: true,
                categories: true,
            },
            orderBy: { createdAt: 'desc' },
        });
    }

    /** Einzelnen Artikel (inkl. Bilder & Kategorien) laden */
    async findOne(id: string): Promise<Article> {
        const article = await this.prisma.article.findUnique({
            where: { id },
            include: {
                images: true,
                categories: true,
            },
        });
        if (!article) throw new NotFoundException(`Article ${id} not found`);
        return article;
    }

    /** Neuen Artikel anlegen, dabei DTO.imageUrls → nested create images */
    async create(dto: CreateArticleDto, authorId: string): Promise<Article> {
        // dto.imageUrls: string[]
        // dto.categoryIds?: string[]
        const imagesCreate = dto.imageUrls.map((url, idx) => ({
            url,
            order: idx,
        }));

        // Prepare nested writes
        const data: Prisma.ArticleCreateInput = {
            title: dto.title,
            subtitle: dto.subtitle,
            content: dto.content,
            author: { connect: { id: authorId } },
            images: { create: imagesCreate },
            categories: dto.categoryIds
                ? { connect: dto.categoryIds.map(id => ({ id })) }
                : undefined,
        };

        return this.prisma.article.create({
            data,
            include: {
                images: true,
                categories: true,
            },
        });
    }

    /** Soft‑Delete: deletedAt setzen */
    async remove(id: string): Promise<void> {
        await this.prisma.article.update({
            where: { id },
            data: { deletedAt: new Date() },
        });
    }
}
