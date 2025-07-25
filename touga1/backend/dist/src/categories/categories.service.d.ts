import { PrismaService } from '../prisma/prisma.service';
import { Category } from '@prisma/client';
export declare class CategoriesService {
    private readonly prisma;
    constructor(prisma: PrismaService);
    findAll(): Promise<Category[]>;
    findOne(id: string): Promise<Category>;
}
