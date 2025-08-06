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
exports.DraftsService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
let DraftsService = class DraftsService {
    prisma;
    constructor(prisma) {
        this.prisma = prisma;
    }
    async create(userId, dto) {
        return this.prisma.draft.create({
            data: {
                authorId: userId,
                title: dto.title,
                subtitle: dto.subtitle,
                content: dto.contentHtml,
                images: dto.images,
            },
        });
    }
    async findOne(draftId) {
        const draft = await this.prisma.draft.findUnique({
            where: { id: draftId },
        });
        if (!draft) {
            throw new common_1.NotFoundException(`Draft with id ${draftId} not found`);
        }
        return draft;
    }
    async update(userId, draftId, dto) {
        const draft = await this.findOne(draftId);
        if (draft.authorId !== userId) {
            throw new common_1.NotFoundException(`Draft not found or unauthorized`);
        }
        const data = {};
        if (dto.title !== undefined)
            data.title = dto.title;
        if (dto.subtitle !== undefined)
            data.subtitle = dto.subtitle;
        if (dto.contentHtml !== undefined)
            data.content = dto.contentHtml;
        if (dto.images !== undefined)
            data.images = dto.images;
        return this.prisma.draft.update({
            where: { id: draftId },
            data,
        });
    }
    async remove(userId, draftId) {
        const draft = await this.findOne(draftId);
        if (draft.authorId !== userId) {
            throw new common_1.NotFoundException(`Draft not found or unauthorized`);
        }
        await this.prisma.draft.delete({ where: { id: draftId } });
        return { deleted: true };
    }
    async publish(userId, draftId) {
        const draft = await this.findOne(draftId);
        if (draft.authorId !== userId) {
            throw new common_1.NotFoundException(`Draft not found or unauthorized`);
        }
        const article = await this.prisma.article.create({
            data: {
                authorId: userId,
                title: draft.title,
                subtitle: draft.subtitle,
                content: draft.content,
                images: {
                    create: draft.images.map((url, index) => ({
                        url,
                        order: index,
                    })),
                },
            },
        });
        await this.prisma.draft.delete({ where: { id: draftId } });
        return article;
    }
};
exports.DraftsService = DraftsService;
exports.DraftsService = DraftsService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], DraftsService);
//# sourceMappingURL=drafts.service.js.map