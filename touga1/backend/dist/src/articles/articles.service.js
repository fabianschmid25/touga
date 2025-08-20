"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ArticlesService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
let ArticlesService = class ArticlesService {
    prisma;
    constructor(prisma) {
        this.prisma = prisma;
    }
    async findAll() {
        const articles = await this.prisma.article.findMany({
            where: { deletedAt: null },
            orderBy: { createdAt: 'desc' },
            include: {
                images: { where: { deletedAt: null } },
                categories: {
                    include: { category: true },
                },
            },
        });
        return articles.map(a => ({
            id: a.id,
            title: a.title,
            template: a.template ?? null,
            excerpt: a.excerpt ?? null,
            categories: a.categories
                .map(ac => ac.category)
                .filter(c => !c.deletedAt)
                .map(c => ({ id: c.id, name: c.name })),
            coverUrl: a.images.find(img => img.order === 0 && !img.deletedAt)?.url ?? null,
            createdAt: a.createdAt,
        }));
    }
    async findOne(id) {
        const article = await this.prisma.article.findUnique({
            where: { id },
            include: {
                images: { where: { deletedAt: null }, orderBy: { order: 'asc' } },
                categories: { include: { category: true } },
                author: true,
            },
        });
        if (!article || article.deletedAt) {
            throw new common_1.NotFoundException(`Article ${id} not found`);
        }
        return {
            id: article.id,
            title: article.title,
            content: article.content,
            excerpt: article.excerpt,
            template: article.template ?? null,
            categories: article.categories
                .map(ac => ac.category)
                .filter(c => !c.deletedAt)
                .map(c => ({ id: c.id, name: c.name })),
            images: article.images.map(img => ({ id: img.id, url: img.url, caption: img.caption, order: img.order })),
            author: article.author ? { id: article.author.id, name: article.author.name, avatarUrl: article.author.avatarUrl } : null,
            publishedAt: article.publishedAt,
            createdAt: article.createdAt,
        };
    }
    async create(dto, authorId) {
        const { title, content, excerpt, template, imageUrls, categoryIds } = dto;
        const article = await this.prisma.article.create({
            data: {
                title,
                content: content ?? null,
                excerpt: excerpt ?? null,
                template: template ?? null,
                authorId,
                publishedAt: new Date(),
                images: {
                    create: (imageUrls ?? []).map((url, index) => ({
                        url,
                        order: index,
                    })),
                },
                ...(categoryIds?.length
                    ? {
                        categories: {
                            createMany: {
                                data: categoryIds.map((categoryId) => ({ categoryId })),
                                skipDuplicates: true,
                            },
                        },
                    }
                    : {}),
            },
            include: {
                images: true,
                categories: { include: { category: true } },
            },
        });
        return {
            id: article.id,
            title: article.title,
            template: article.template,
            excerpt: article.excerpt,
            categories: article.categories.map(ac => ({ id: ac.category.id, name: ac.category.name })),
            coverUrl: article.images.find(i => i.order === 0)?.url ?? null,
        };
    }
    async remove(id) {
        await this.prisma.article.update({
            where: { id },
            data: { deletedAt: new Date() },
        });
    }
};
exports.ArticlesService = ArticlesService;
exports.ArticlesService = ArticlesService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], ArticlesService);
//# sourceMappingURL=articles.service.js.map