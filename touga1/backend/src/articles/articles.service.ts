import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateArticleDto } from './dto/create-article.dto';
import { Article } from '@prisma/client';

@Injectable()
export class ArticlesService {
    constructor(private readonly prisma: PrismaService) { }

    /**
     * Gibt alle Artikel sortiert nach Erstellungsdatum (neueste zuerst) zurück.
     */
    findAll(): Promise<Article[]> {
        return this.prisma.article.findMany({
            orderBy: { createdAt: 'desc' },
            select: {
                id: true,
                title: true,
                content: true,
                subtitle: true,
                imageUrls: true,
                authorId: true,
                createdAt: true,
            },
        });
    }

    /**
     * Gibt einen einzelnen Artikel anhand seiner ID zurück.
     */
    findOne(id: string): Promise<Article | null> {
        return this.prisma.article.findUnique({
            where: { id },
            select: {
                id: true,
                title: true,
                content: true,
                subtitle: true,
                imageUrls: true,
                authorId: true,
                createdAt: true,
            },
        });
    }

    /**
     * Legt einen neuen Artikel an.
     * Wenn der Author noch nicht existiert, wird er zuvor per upsert angelegt.
     */
    async create(dto: CreateArticleDto): Promise<Article> {
        const userId = '00000000-0000-0000-0000-000000000000';

        // 1) User upserten (falls nicht vorhanden)
        await this.prisma.user.upsert({
            where: { id: userId },
            update: {},  // keine Änderungen, wenn der User bereits existiert
            create: {
                id: userId,
                email: 'test@example.com', // mindestens required-Feld(e) deines User-Modells
            },
        });

        // 2) Artikel mit authorId anlegen
        return this.prisma.article.create({
            data: {
                title: dto.title,
                content: dto.content,
                subtitle: dto.subtitle,
                imageUrls: dto.imageUrls,
                authorId: userId,
            },
        });
    }
}