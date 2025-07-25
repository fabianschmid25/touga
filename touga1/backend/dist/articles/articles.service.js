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
    findAll() {
        return this.prisma.article.findMany({
            orderBy: { createdAt: 'desc' },
            select: {
                id: true,
                title: true,
                content: true,
                subtitle: true,
                imageUrls: true,
                authorId: true,
                createdAt: true,
            },
        });
    }
    findOne(id) {
        return this.prisma.article.findUnique({
            where: { id },
            select: {
                id: true,
                title: true,
                content: true,
                subtitle: true,
                imageUrls: true,
                authorId: true,
                createdAt: true,
            },
        });
    }
    async create(dto) {
        const userId = '00000000-0000-0000-0000-000000000000';
        await this.prisma.user.upsert({
            where: { id: userId },
            update: {},
            create: {
                id: userId,
                email: 'test@example.com',
            },
        });
        return this.prisma.article.create({
            data: {
                title: dto.title,
                content: dto.content,
                subtitle: dto.subtitle,
                imageUrls: dto.imageUrls,
                authorId: userId,
            },
        });
    }
};
exports.ArticlesService = ArticlesService;
exports.ArticlesService = ArticlesService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], ArticlesService);
//# sourceMappingURL=articles.service.js.map