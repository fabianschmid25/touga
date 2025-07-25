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
            // Variante 2: Dummy‑User bis Auth implementiert ist.
            // TODO später: mit JWT‑Guard o.ä. ersetzen und req.user.id übergeben. ersetzten mit const authorId = req.user.id;
            const DUMMY_USER_ID = '00000000-0000-0000-0000-000000000000';
            return this.svc.create(dto, DUMMY_USER_ID);
        } catch (err) {
            console.error('Error creating article:', err);
            throw new InternalServerErrorException(err.message);
        }
    }
}
