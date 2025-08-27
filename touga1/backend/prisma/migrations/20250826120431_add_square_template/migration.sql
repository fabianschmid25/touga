-- AlterEnum
-- This migration adds more than one value to an enum.
-- With PostgreSQL versions 11 and earlier, this is not possible
-- in a single migration. This can be worked around by creating
-- multiple migrations, each migration adding only one value to
-- the enum.


ALTER TYPE "ArticleTemplate" ADD VALUE 'CARD_3_4_V1';
ALTER TYPE "ArticleTemplate" ADD VALUE 'CARD_3_4_V2';
ALTER TYPE "ArticleTemplate" ADD VALUE 'STORY_4_3_V1';
ALTER TYPE "ArticleTemplate" ADD VALUE 'STORY_4_3_V2';
