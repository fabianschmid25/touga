// src/drafts/dto/update-draft.dto.ts

import { IsString, IsOptional, IsArray, IsUrl } from 'class-validator';
import { PartialType } from '@nestjs/mapped-types';
import { CreateDraftDto } from './create-draft.dto';



export class UpdateDraftDto extends PartialType(CreateDraftDto) {
    @IsOptional()
    @IsString()
    title?: string;

    @IsOptional()
    @IsString()
    subtitle?: string;

    @IsOptional()
    @IsString()
    contentHtml?: string;

    @IsOptional()
    @IsArray()
    @IsUrl({}, { each: true })
    images?: string[];
}
