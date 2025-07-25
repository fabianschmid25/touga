import { CategoriesService } from './categories.service';
import { Category } from '@prisma/client';
export declare class CategoriesController {
    private readonly svc;
    constructor(svc: CategoriesService);
    findAll(): Promise<Category[]>;
    findOne(id: string): Promise<Category>;
}
