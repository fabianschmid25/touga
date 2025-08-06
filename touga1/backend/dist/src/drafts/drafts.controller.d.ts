import { DraftsService } from './drafts.service';
import { CreateDraftDto } from './dto/create-draft.dto';
import { UpdateDraftDto } from './dto/update-draft.dto';
export declare class DraftsController {
    private readonly draftsService;
    constructor(draftsService: DraftsService);
    create(req: any, dto: CreateDraftDto): Promise<{
        id: string;
        createdAt: Date;
        updatedAt: Date;
        title: string;
        subtitle: string | null;
        content: import("@prisma/client/runtime/library").JsonValue;
        authorId: string;
        images: string[];
    }>;
    findOne(req: any, id: string): Promise<{
        id: string;
        createdAt: Date;
        updatedAt: Date;
        title: string;
        subtitle: string | null;
        content: import("@prisma/client/runtime/library").JsonValue;
        authorId: string;
        images: string[];
    }>;
    update(req: any, id: string, dto: UpdateDraftDto): Promise<{
        id: string;
        createdAt: Date;
        updatedAt: Date;
        title: string;
        subtitle: string | null;
        content: import("@prisma/client/runtime/library").JsonValue;
        authorId: string;
        images: string[];
    }>;
    remove(req: any, id: string): Promise<{
        deleted: boolean;
    }>;
    publish(req: any, id: string): Promise<{
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
