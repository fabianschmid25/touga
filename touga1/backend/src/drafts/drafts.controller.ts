import {
    Controller,
    Post,
    Get,
    Patch,
    Delete,
    Param,
    Body,
    UseGuards,
    Req,
} from '@nestjs/common';
import { DraftsService } from './drafts.service';
import { CreateDraftDto } from './dto/create-draft.dto';
import { UpdateDraftDto } from './dto/update-draft.dto';
// Passe den Pfad hier an, je nachdem wo dein JwtAuthGuard liegt:
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@UseGuards(JwtAuthGuard)
@Controller('drafts')
export class DraftsController {
    constructor(private readonly draftsService: DraftsService) { }

    @Post()
    create(@Req() req, @Body() dto: CreateDraftDto) {
        return this.draftsService.create(req.user.id, dto);
    }

    @Get(':id')
    findOne(@Req() req, @Param('id') id: string) {
        return this.draftsService.findOne(id);
    }

    @Patch(':id')
    update(
        @Req() req,
        @Param('id') id: string,
        @Body() dto: UpdateDraftDto,
    ) {
        return this.draftsService.update(req.user.id, id, dto);
    }

    @Delete(':id')
    remove(@Req() req, @Param('id') id: string) {
        return this.draftsService.remove(req.user.id, id);
    }

    @Post(':id/publish')
    publish(@Req() req, @Param('id') id: string) {
        return this.draftsService.publish(req.user.id, id);
    }
}
