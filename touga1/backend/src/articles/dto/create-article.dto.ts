// src/articles/dto/create-article.dto.ts
import { IsString, IsNotEmpty, IsArray, ArrayNotEmpty } from 'class-validator';

export class CreateArticleDto {
    @IsString() @IsNotEmpty()
    title: string;

    @IsString() @IsNotEmpty()
    content: string;

    @IsString()
    subtitle?: string;

    @IsArray() @ArrayNotEmpty()
    imageUrls: string[];
}
