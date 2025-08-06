import { CreateDraftDto } from './create-draft.dto';
declare const UpdateDraftDto_base: import("@nestjs/mapped-types").MappedType<Partial<CreateDraftDto>>;
export declare class UpdateDraftDto extends UpdateDraftDto_base {
    title?: string;
    subtitle?: string;
    contentHtml?: string;
    images?: string[];
}
export {};
