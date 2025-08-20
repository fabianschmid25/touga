import { PrismaService } from '../prisma/prisma.service';
import { CreateDraftDto } from './dto/create-draft.dto';
import { UpdateDraftDto } from './dto/update-draft.dto';
export declare class DraftsService {
    private readonly prisma;
    constructor(prisma: PrismaService);
    create(userId: string, dto: CreateDraftDto): Promise<{
        id: string;
        createdAt: Date;
        updatedAt: Date;
        deletedAt: Date | null;
        authorId: string;
        title: string | null;
        images: string[];
        contentHtml: string | null;
    }>;
    findOne(draftId: string): Promise<{
        id: string;
        createdAt: Date;
        updatedAt: Date;
        deletedAt: Date | null;
        authorId: string;
        title: string | null;
        images: string[];
        contentHtml: string | null;
    }>;
    update(userId: string, draftId: string, dto: UpdateDraftDto): Promise<{
        id: string;
        createdAt: Date;
        updatedAt: Date;
        deletedAt: Date | null;
        authorId: string;
        title: string | null;
        images: string[];
        contentHtml: string | null;
    }>;
    remove(userId: string, draftId: string): Promise<{
        deleted: boolean;
    }>;
    publish(userId: string, draftId: string): Promise<{
        id: string;
        createdAt: Date;
        updatedAt: Date;
        deletedAt: Date | null;
        authorId: string;
        title: string;
        content: string | null;
        excerpt: string | null;
        template: import(".prisma/client").$Enums.ArticleTemplate | null;
        publishedAt: Date | null;
    }>;
}
