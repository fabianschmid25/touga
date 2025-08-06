// src/drafts/drafts.service.ts

import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateDraftDto } from './dto/create-draft.dto';
import { UpdateDraftDto } from './dto/update-draft.dto';

@Injectable()
export class DraftsService {
    constructor(private readonly prisma: PrismaService) { }

    /** Erstelle einen neuen Draft und speichere HTML in das JSON-Feld `content` */
    async create(userId: string, dto: CreateDraftDto) {
        return this.prisma.draft.create({
            data: {
                authorId: userId,
                title: dto.title,
                subtitle: dto.subtitle,
                content: dto.contentHtml,  // Mapping von contentHtml auf das JSON-Feld
                images: dto.images,        // Array von Bild-URLs
            },
        });
    }

    /** Liefere einen einzelnen Draft oder 404 */
    async findOne(draftId: string) {
        const draft = await this.prisma.draft.findUnique({
            where: { id: draftId },
        });
        if (!draft) {
            throw new NotFoundException(`Draft with id ${draftId} not found`);
        }
        return draft;
    }

    /** Update-Felder des Drafts (einschließlich HTML-Content) */
    async update(userId: string, draftId: string, dto: UpdateDraftDto) {
        const draft = await this.findOne(draftId);
        if (draft.authorId !== userId) {
            throw new NotFoundException(`Draft not found or unauthorized`);
        }

        const data: Record<string, any> = {};
        if (dto.title !== undefined) data.title = dto.title;
        if (dto.subtitle !== undefined) data.subtitle = dto.subtitle;
        if (dto.contentHtml !== undefined) data.content = dto.contentHtml; // Mapping
        if (dto.images !== undefined) data.images = dto.images;

        return this.prisma.draft.update({
            where: { id: draftId },
            data,
        });
    }

    /** Lösche einen Draft */
    async remove(userId: string, draftId: string) {
        const draft = await this.findOne(draftId);
        if (draft.authorId !== userId) {
            throw new NotFoundException(`Draft not found or unauthorized`);
        }
        await this.prisma.draft.delete({ where: { id: draftId } });
        return { deleted: true };
    }

    /** Publiziere den Draft als echten Artikel und lösche den Draft */
    async publish(userId: string, draftId: string) {
        const draft = await this.findOne(draftId);
        if (draft.authorId !== userId) {
            throw new NotFoundException(`Draft not found or unauthorized`);
        }

        const article = await this.prisma.article.create({
            data: {
                authorId: userId,
                title: draft.title,
                subtitle: draft.subtitle,
                content: draft.content as string,  // Cast auf String, um Prisma-Typ zu erfüllen
                images: {
                    create: draft.images.map((url, index) => ({
                        url,
                        order: index,
                    })),
                },
            },
        });

        await this.prisma.draft.delete({ where: { id: draftId } });
        return article;
    }
}
