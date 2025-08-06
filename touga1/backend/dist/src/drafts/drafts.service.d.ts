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
        title: string;
        subtitle: string | null;
        content: import("@prisma/client/runtime/library").JsonValue;
        authorId: string;
        images: string[];
    }>;
    findOne(draftId: string): Promise<{
        id: string;
        createdAt: Date;
        updatedAt: Date;
        title: string;
        subtitle: string | null;
        content: import("@prisma/client/runtime/library").JsonValue;
        authorId: string;
        images: string[];
    }>;
    update(userId: string, draftId: string, dto: UpdateDraftDto): Promise<{
        id: string;
        createdAt: Date;
        updatedAt: Date;
        title: string;
        subtitle: string | null;
        content: import("@prisma/client/runtime/library").JsonValue;
        authorId: string;
        images: string[];
    }>;
    remove(userId: string, draftId: string): Promise<{
        deleted: boolean;
    }>;
    publish(userId: string, draftId: string): Promise<{
        id: string;
        createdAt: Date;
        updatedAt: Date;
        deletedAt: Date | null;
        title: string;
        subtitle: string | null;
        content: string;
        viewCount: number;
        authorId: string;
    }>;
}
