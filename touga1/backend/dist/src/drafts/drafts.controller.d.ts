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
        deletedAt: Date | null;
        authorId: string;
        title: string | null;
        images: string[];
        contentHtml: string | null;
    }>;
    findOne(req: any, id: string): Promise<{
        id: string;
        createdAt: Date;
        updatedAt: Date;
        deletedAt: Date | null;
        authorId: string;
        title: string | null;
        images: string[];
        contentHtml: string | null;
    }>;
    update(req: any, id: string, dto: UpdateDraftDto): Promise<{
        id: string;
        createdAt: Date;
        updatedAt: Date;
        deletedAt: Date | null;
        authorId: string;
        title: string | null;
        images: string[];
        contentHtml: string | null;
    }>;
    remove(req: any, id: string): Promise<{
        deleted: boolean;
    }>;
    publish(req: any, id: string): Promise<{
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
