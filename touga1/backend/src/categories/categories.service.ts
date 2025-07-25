// backend/src/categories/categories.service.ts

import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { Category } from '@prisma/client';

@Injectable()
export class CategoriesService {
    constructor(private readonly prisma: PrismaService) { }

    /** Alle nicht‑gelöschten Kategorien */
    async findAll(): Promise<Category[]> {
        return this.prisma.category.findMany({
            where: { deletedAt: null },
            orderBy: { name: 'asc' },
        });
    }

    /** Einzelne Kategorie suchen */
    async findOne(id: string): Promise<Category> {
        const category = await this.prisma.category.findUnique({
            where: { id },
        });
        if (!category || category.deletedAt) {
            throw new NotFoundException(`Category ${id} not found`);
        }
        return category;
    }
}
