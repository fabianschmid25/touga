// src/articles/dto/create-article.dto.ts
import { IsString, IsNotEmpty, IsArray, ArrayNotEmpty, IsOptional, IsUUID, IsEnum } from 'class-validator';
import { ArticleTemplate } from '@prisma/client';

export class CreateArticleDto {
    @IsString() @IsNotEmpty()
    title!: string;

    @IsString() @IsOptional()
    subtitle?: string;

    @IsString() @IsNotEmpty()
    content!: string;

    @IsEnum(ArticleTemplate) @IsOptional()
    template?: ArticleTemplate; // FULL_9_16 | CARD_3_4 | STORY_4_3

    @IsArray() @ArrayNotEmpty()
    @IsString({ each: true })
    imageUrls!: string[];

    @IsArray() @IsOptional()
    @IsUUID('4', { each: true })
    categoryIds?: string[];
}
