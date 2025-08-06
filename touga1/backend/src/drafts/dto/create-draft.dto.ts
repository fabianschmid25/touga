//src/drafts/dto/create-draft.dto.ts
import { IsString, IsOptional, IsArray, IsUrl } from 'class-validator';

export class CreateDraftDto {
    @IsString()
    title: string;

    @IsOptional()
    @IsString()
    subtitle?: string;

    @IsString()
    contentHtml: string;

    @IsArray()
    @IsUrl({}, { each: true })
    images: string[];
}
