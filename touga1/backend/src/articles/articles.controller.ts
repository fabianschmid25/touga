// src/articles/articles.controller.ts
import {
    Controller,
    Get,
    Post,
    Body,
    Param,
    ValidationPipe,
    UsePipes,
    InternalServerErrorException,
} from '@nestjs/common';
import { ArticlesService } from './articles.service';
import { CreateArticleDto } from './dto/create-article.dto';
import { Article } from '@prisma/client';

@Controller('articles')
export class ArticlesController {
    constructor(private svc: ArticlesService) { }

    @Get()
    getAll(): Promise<Article[]> {
        return this.svc.findAll();
    }

    @Get(':id')
    getOne(@Param('id') id: string): Promise<Article | null> {
        return this.svc.findOne(id);
    }

    @Post()
    async create(@Body() dto: CreateArticleDto): Promise<Article> {
        try {
            return await this.svc.create(dto);
        } catch (err) {
            console.error('Error creating article:', err);
            throw new InternalServerErrorException(err.message);
        }
    }
}
