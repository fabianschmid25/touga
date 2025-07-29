// backend/src/auth/auth.service.ts

import {
    Injectable,
    ForbiddenException,
    UnauthorizedException,
    Logger,
    HttpException,
    HttpStatus,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import * as bcrypt from 'bcrypt';
import { JwtService } from '@nestjs/jwt';
import { RegisterDto, LoginDto } from './dto';

@Injectable()
export class AuthService {
    private readonly logger = new Logger(AuthService.name);

    constructor(
        private prisma: PrismaService,
        private jwtService: JwtService,
    ) { }

    async register(dto: RegisterDto) {
        this.logger.debug(`AuthService.register() – email: ${dto.email}`);
        const existing = await this.prisma.user.findUnique({ where: { email: dto.email } });
        if (existing) {
            this.logger.warn(`AuthService.register() – email already in use: ${dto.email}`);
            throw new ForbiddenException('Email already in use');
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

    async validateUser(email: string, password: string) {
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

    async login(dto: LoginDto) {
        this.logger.debug(`AuthService.login() – attempt for email: ${dto.email}`);
        try {
            const user = await this.validateUser(dto.email, dto.password);
            if (!user) {
                this.logger.warn(`AuthService.login() – invalid credentials for ${dto.email}`);
                throw new ForbiddenException('Invalid credentials');
            }
            const tokens = await this.signTokens(user.id, user.email);
            this.logger.log(`AuthService.login() – success for userId: ${user.id}`);
            return tokens;
        } catch (e) {
            this.logger.error(`AuthService.login() – error for ${dto.email}`, e.stack);
            if (e instanceof HttpException) throw e;
            throw new HttpException('Login failed due to server error', HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    private async signTokens(userId: string, email: string) {
        const accessToken = await this.jwtService.signAsync(
            { sub: userId, email },
            { expiresIn: '15m' },
        );
        const refreshToken = await this.jwtService.signAsync(
            { sub: userId },
            { expiresIn: '7d' },
        );
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

    async refreshTokens(rt: string) {
        this.logger.debug(`AuthService.refreshTokens() – starting refresh`);
        const payload = this.jwtService.decode(rt) as { sub?: string };
        if (!payload?.sub) {
            this.logger.warn(`AuthService.refreshTokens() – invalid payload`);
            throw new UnauthorizedException('Invalid refresh token');
        }

        const records = await this.prisma.refreshToken.findMany({
            where: { userId: payload.sub },
            orderBy: { createdAt: 'desc' },
            take: 1,
        });
        if (!records.length) {
            this.logger.warn(`AuthService.refreshTokens() – no token record for userId: ${payload.sub}`);
            throw new ForbiddenException('Refresh token not found');
        }

        const record = records[0];
        const valid = await bcrypt.compare(rt, record.tokenHash);
        if (!valid) {
            this.logger.warn(`AuthService.refreshTokens() – token mismatch for userId: ${payload.sub}`);
            throw new ForbiddenException('Refresh token mismatch');
        }

        // Alten Token löschen
        await this.prisma.refreshToken.delete({ where: { id: record.id } });

        // User laden
        const user = await this.getUserById(payload.sub);
        return this.signTokens(payload.sub, user.email);
    }

    async logout(userId: string) {
        this.logger.debug(`AuthService.logout() – deleting tokens for userId: ${userId}`);
        await this.prisma.refreshToken.deleteMany({ where: { userId } });
        this.logger.log(`AuthService.logout() – done for userId: ${userId}`);
        return { success: true };
    }

    /** Neu: User per ID abrufen (wird in JwtStrategy gebraucht) */
    async getUserById(id: string) {
        this.logger.debug(`AuthService.getUserById() – id: ${id}`);
        const user = await this.prisma.user.findUnique({ where: { id } });
        if (!user) {
            this.logger.warn(`AuthService.getUserById() – user not found: ${id}`);
            throw new UnauthorizedException('User not found');
        }
        return user;
    }
}
