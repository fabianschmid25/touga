import { PrismaService } from '../prisma/prisma.service';
import { JwtService } from '@nestjs/jwt';
import { RegisterDto, LoginDto } from './dto';
export declare class AuthService {
    private prisma;
    private jwtService;
    private readonly logger;
    constructor(prisma: PrismaService, jwtService: JwtService);
    register(dto: RegisterDto): Promise<{
        accessToken: string;
        refreshToken: string;
    }>;
    validateUser(email: string, password: string): Promise<{
        id: string;
        email: string;
        passwordHash: string;
        name: string | null;
        avatarUrl: string | null;
        role: import(".prisma/client").$Enums.Role;
        createdAt: Date;
        updatedAt: Date;
        deletedAt: Date | null;
    } | null>;
    login(dto: LoginDto): Promise<{
        accessToken: string;
        refreshToken: string;
    }>;
    private signTokens;
    refreshTokens(rt: string): Promise<{
        accessToken: string;
        refreshToken: string;
    }>;
    logout(userId: string): Promise<{
        success: boolean;
    }>;
    getUserById(id: string): Promise<{
        id: string;
        email: string;
        passwordHash: string;
        name: string | null;
        avatarUrl: string | null;
        role: import(".prisma/client").$Enums.Role;
        createdAt: Date;
        updatedAt: Date;
        deletedAt: Date | null;
    }>;
}
