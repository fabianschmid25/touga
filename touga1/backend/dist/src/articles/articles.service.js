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
        return this.prisma.article.findMany({
            where: { deletedAt: null },
            include: {
                images: true,
                categories: true,
            },
            orderBy: { createdAt: 'desc' },
        });
    }
    async findOne(id) {
        const article = await this.prisma.article.findUnique({
            where: { id },
            include: {
                images: true,
                categories: true,
            },
        });
        if (!article)
            throw new common_1.NotFoundException(`Article ${id} not found`);
        return article;
    }
    async create(dto, authorId) {
        const imagesCreate = dto.imageUrls.map((url, idx) => ({
            url,
            order: idx,
        }));
        const data = {
            title: dto.title,
            subtitle: dto.subtitle,
            content: dto.content,
            author: { connect: { id: authorId } },
            images: { create: imagesCreate },
            categories: dto.categoryIds
                ? { connect: dto.categoryIds.map(id => ({ id })) }
                : undefined,
        };
        return this.prisma.article.create({
            data,
            include: {
                images: true,
                categories: true,
            },
        });
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