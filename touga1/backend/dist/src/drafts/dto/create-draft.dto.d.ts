import { ArticleTemplate } from '@prisma/client';
export declare class CreateDraftDto {
    title: string;
    subtitle?: string;
    contentHtml: string;
    template?: ArticleTemplate;
    images: string[];
}
