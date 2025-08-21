//src/drafts/dto/create-draft.dto.ts
import { IsString, IsOptional, IsArray, IsUrl, IsEnum } from 'class-validator';
import { ArticleTemplate } from '@prisma/client';

export class CreateDraftDto {
    @IsString()
    title: string;

    @IsOptional()
    @IsString()
    subtitle?: string;

    @IsString()
    contentHtml: string;

    @IsEnum(ArticleTemplate) @IsOptional()
    template?: ArticleTemplate; // FULL_9_16 | CARD_3_4 | STORY_4_3

    @IsArray()
    @IsUrl({}, { each: true })
    images: string[];
}
