import { PrismaService } from '../prisma/prisma.service';
import { CreateArticleDto } from './dto/create-article.dto';
export declare class ArticlesService {
    private readonly prisma;
    constructor(prisma: PrismaService);
    findAll(): Promise<{
        id: string;
        title: string;
        template: import(".prisma/client").$Enums.ArticleTemplate | null;
        excerpt: string | null;
        categories: {
            id: string;
            name: string;
        }[];
        coverUrl: string | null;
        createdAt: Date;
    }[]>;
    findOne(id: string): Promise<{
        id: string;
        title: string;
        content: string | null;
        excerpt: string | null;
        template: import(".prisma/client").$Enums.ArticleTemplate | null;
        categories: {
            id: string;
            name: string;
        }[];
        images: {
            id: string;
            url: string;
            caption: string | null;
            order: number;
        }[];
        author: {
            id: string;
            name: string | null;
            avatarUrl: string | null;
        } | null;
        publishedAt: Date | null;
        createdAt: Date;
    }>;
    create(dto: CreateArticleDto, authorId: string): Promise<{
        id: string;
        title: string;
        template: import(".prisma/client").$Enums.ArticleTemplate | null;
        excerpt: string | null;
        categories: {
            id: string;
            name: string;
        }[];
        coverUrl: string | null;
    }>;
    remove(id: string): Promise<void>;
}
