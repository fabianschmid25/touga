import { ArticlesService } from './articles.service';
import { CreateArticleDto } from './dto/create-article.dto';
import { Article } from '@prisma/client';
export declare class ArticlesController {
    private svc;
    constructor(svc: ArticlesService);
    getAll(): Promise<Article[]>;
    getOne(id: string): Promise<Article | null>;
    create(dto: CreateArticleDto): Promise<Article>;
}
