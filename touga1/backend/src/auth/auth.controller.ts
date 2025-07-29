// backend/src/auth/auth.controller.ts
import { Controller, Post, Body, UseGuards, Req, Logger } from '@nestjs/common';
import { AuthService } from './auth.service';
import { RegisterDto, LoginDto } from './dto';
import { JwtAuthGuard } from './guards/jwt-auth.guard';

@Controller('auth')
export class AuthController {
    private readonly logger = new Logger(AuthController.name);

    constructor(private readonly authService: AuthService) { }

    @Post('register')
    async register(@Body() dto: RegisterDto) {
        this.logger.debug(`AuthController.register() – payload: ${JSON.stringify(dto)}`);
        return this.authService.register(dto);
    }

    @Post('login')
    async login(@Body() dto: LoginDto) {
        this.logger.debug(`AuthController.login() – payload: ${JSON.stringify(dto)}`);
        return this.authService.login(dto);
    }

    @Post('refresh')
    async refresh(@Body('refreshToken') refreshToken: string) {
        this.logger.debug(`AuthController.refresh() – refreshToken received`);
        return this.authService.refreshTokens(refreshToken);
    }

    @UseGuards(JwtAuthGuard)
    @Post('logout')
    async logout(@Req() req) {
        this.logger.debug(`AuthController.logout() – userId: ${req.user.id}`);
        return this.authService.logout(req.user.id);
    }
}
