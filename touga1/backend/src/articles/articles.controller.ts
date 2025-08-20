// src/articles/articles.controller.ts
import { Controller, Get, Post, Body, Param, InternalServerErrorException } from '@nestjs/common';
import { ArticlesService } from './articles.service';
import { CreateArticleDto } from './dto/create-article.dto';

@Controller('articles')
export class ArticlesController {
    constructor(private readonly svc: ArticlesService) { }

    /** GET /articles – Feed */
    @Get()
    async findAll() {
        return this.svc.findAll();
    }

    /** GET /articles/:id – Detail */
    @Get(':id')
    async findOne(@Param('id') id: string) {
        return this.svc.findOne(id);
    }

    /** POST /articles – optional (falls gerade nicht genutzt) */
    @Post()
    async create(@Body() dto: CreateArticleDto) {
        try {
            // Dummy-User bis Auth implementiert ist. (später JwtGuard + req.user.id)
            const DUMMY_USER_ID = '00000000-0000-0000-0000-000000000000';
            return this.svc.create(dto, DUMMY_USER_ID);
        } catch (err) {
            console.error('Error creating article:', err);
            throw new InternalServerErrorException(err.message);
        }
    }
}
