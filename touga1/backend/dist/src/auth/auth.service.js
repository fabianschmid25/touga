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
var AuthService_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.AuthService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
const bcrypt = require("bcrypt");
const jwt_1 = require("@nestjs/jwt");
let AuthService = AuthService_1 = class AuthService {
    prisma;
    jwtService;
    logger = new common_1.Logger(AuthService_1.name);
    constructor(prisma, jwtService) {
        this.prisma = prisma;
        this.jwtService = jwtService;
    }
    async register(dto) {
        this.logger.debug(`AuthService.register() – email: ${dto.email}`);
        const existing = await this.prisma.user.findUnique({ where: { email: dto.email } });
        if (existing) {
            this.logger.warn(`AuthService.register() – email already in use: ${dto.email}`);
            throw new common_1.ForbiddenException('Email already in use');
        }
        const hash = await bcrypt.hash(dto.password, 10);
        const user = await this.prisma.user.create({
            data: {
                email: dto.email,
                passwordHash: hash,
                name: dto.name,
            },
        });
        this.logger.log(`AuthService.register() – user created: ${user.id}`);
        return this.signTokens(user.id, user.email);
    }
    async validateUser(email, password) {
        this.logger.debug(`AuthService.validateUser() – email: ${email}`);
        const user = await this.prisma.user.findUnique({ where: { email } });
        if (!user) {
            this.logger.warn(`AuthService.validateUser() – no user for email: ${email}`);
            return null;
        }
        const matches = await bcrypt.compare(password, user.passwordHash);
        if (!matches) {
            this.logger.warn(`AuthService.validateUser() – wrong password for email: ${email}`);
            return null;
        }
        this.logger.debug(`AuthService.validateUser() – password valid for email: ${email}`);
        return user;
    }
    async login(dto) {
        this.logger.debug(`AuthService.login() – attempt for email: ${dto.email}`);
        try {
            const user = await this.validateUser(dto.email, dto.password);
            if (!user) {
                this.logger.warn(`AuthService.login() – invalid credentials for ${dto.email}`);
                throw new common_1.ForbiddenException('Invalid credentials');
            }
            const tokens = await this.signTokens(user.id, user.email);
            this.logger.log(`AuthService.login() – success for userId: ${user.id}`);
            return tokens;
        }
        catch (e) {
            this.logger.error(`AuthService.login() – error for ${dto.email}`, e.stack);
            if (e instanceof common_1.HttpException)
                throw e;
            throw new common_1.HttpException('Login failed due to server error', common_1.HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    async signTokens(userId, email) {
        const accessToken = await this.jwtService.signAsync({ sub: userId, email }, { expiresIn: '15m' });
        const refreshToken = await this.jwtService.signAsync({ sub: userId }, { expiresIn: '7d' });
        const hashedRt = await bcrypt.hash(refreshToken, 10);
        await this.prisma.refreshToken.create({
            data: {
                userId,
                tokenHash: hashedRt,
                expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000),
            },
        });
        this.logger.debug(`AuthService.signTokens() – tokens signed for userId: ${userId}`);
        return { accessToken, refreshToken };
    }
    async refreshTokens(rt) {
        this.logger.debug(`AuthService.refreshTokens() – starting refresh`);
        const payload = this.jwtService.decode(rt);
        if (!payload?.sub) {
            this.logger.warn(`AuthService.refreshTokens() – invalid payload`);
            throw new common_1.UnauthorizedException('Invalid refresh token');
        }
        const records = await this.prisma.refreshToken.findMany({
            where: { userId: payload.sub },
            orderBy: { createdAt: 'desc' },
            take: 1,
        });
        if (!records.length) {
            this.logger.warn(`AuthService.refreshTokens() – no token record for userId: ${payload.sub}`);
            throw new common_1.ForbiddenException('Refresh token not found');
        }
        const record = records[0];
        const valid = await bcrypt.compare(rt, record.tokenHash);
        if (!valid) {
            this.logger.warn(`AuthService.refreshTokens() – token mismatch for userId: ${payload.sub}`);
            throw new common_1.ForbiddenException('Refresh token mismatch');
        }
        await this.prisma.refreshToken.delete({ where: { id: record.id } });
        const user = await this.getUserById(payload.sub);
        return this.signTokens(payload.sub, user.email);
    }
    async logout(userId) {
        this.logger.debug(`AuthService.logout() – deleting tokens for userId: ${userId}`);
        await this.prisma.refreshToken.deleteMany({ where: { userId } });
        this.logger.log(`AuthService.logout() – done for userId: ${userId}`);
        return { success: true };
    }
    async getUserById(id) {
        this.logger.debug(`AuthService.getUserById() – id: ${id}`);
        const user = await this.prisma.user.findUnique({ where: { id } });
        if (!user) {
            this.logger.warn(`AuthService.getUserById() – user not found: ${id}`);
            throw new common_1.UnauthorizedException('User not found');
        }
        return user;
    }
};
exports.AuthService = AuthService;
exports.AuthService = AuthService = AuthService_1 = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService,
        jwt_1.JwtService])
], AuthService);
//# sourceMappingURL=auth.service.js.map