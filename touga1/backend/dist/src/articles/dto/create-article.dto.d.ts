import { ArticleTemplate } from '@prisma/client';
export declare class CreateArticleDto {
    title: string;
    subtitle?: string;
    content: string;
    template?: ArticleTemplate;
    imageUrls: string[];
    categoryIds?: string[];
}
