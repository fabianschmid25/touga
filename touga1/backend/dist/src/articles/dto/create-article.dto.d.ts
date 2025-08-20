import { ArticleTemplate } from '@prisma/client';
export declare class CreateArticleDto {
    title: string;
    content?: string;
    excerpt?: string;
    template?: ArticleTemplate;
    imageUrls: string[];
    categoryIds?: string[];
}
