// backend/src/categories/categories.controller.ts

import { Controller, Get, Param } from '@nestjs/common';
import { CategoriesService } from './categories.service';
import { Category } from '@prisma/client';

@Controller('categories')
export class CategoriesController {
    constructor(private readonly svc: CategoriesService) { }

    /** GET /categories */
    @Get()
    findAll(): Promise<Category[]> {
        return this.svc.findAll();
    }

    /** GET /categories/:id */
    @Get(':id')
    findOne(@Param('id') id: string): Promise<Category> {
        return this.svc.findOne(id);
    }
}
