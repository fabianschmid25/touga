// src/articles/dto/create-article.dto.ts
import { IsString, IsNotEmpty, IsArray, ArrayNotEmpty, IsOptional, IsUUID } from 'class-validator';

export class CreateArticleDto {
    @IsString() @IsNotEmpty()
    title!: string;

    @IsString() @IsOptional()
    subtitle?: string;

    @IsString() @IsNotEmpty()
    content!: string;

    @IsArray() @ArrayNotEmpty()
    @IsString({ each: true })
    imageUrls!: string[];

    @IsArray() @IsOptional()
    @IsUUID('4', { each: true })
    categoryIds?: string[];
}
