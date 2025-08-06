import { Module } from '@nestjs/common';
import { DraftsService } from './drafts.service';
import { DraftsController } from './drafts.controller';
import { PrismaService } from '../prisma/prisma.service';

@Module({
    controllers: [DraftsController],
    providers: [DraftsService, PrismaService],
})
export class DraftsModule { }
