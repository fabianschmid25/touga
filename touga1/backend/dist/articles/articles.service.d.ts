import { PrismaService } from '../prisma/prisma.service';
import { CreateArticleDto } from './dto/create-article.dto';
import { Article } from '@prisma/client';
export declare class ArticlesService {
    private readonly prisma;
    constructor(prisma: PrismaService);
    findAll(): Promise<Article[]>;
    findOne(id: string): Promise<Article | null>;
    create(dto: CreateArticleDto): Promise<Article>;
}
