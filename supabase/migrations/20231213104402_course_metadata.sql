alter table "public"."course" alter column "metadata" set default '{"goals": "", "description": "", "requirements": ""}'::jsonb;
