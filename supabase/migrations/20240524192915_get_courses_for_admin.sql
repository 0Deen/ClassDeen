drop function if exists "public"."get_courses"(org_id_arg uuid, profile_id_arg uuid);

create
or replace function public.get_courses (org_id_arg uuid, profile_id_arg uuid) returns table (
  id uuid,
  org_id uuid,
  title character varying,
  slug character varying,
  description character varying,
  logo text,
  banner_image text,
  cost bigint,
  currency character varying,
  is_published boolean,
  total_lessons bigint,
  total_students bigint,
  progress_rate bigint,
  type "COURSE_TYPE",
  member_profile_id uuid
) language plpgsql as $function$
BEGIN
  Return query
  select course.id, organization.id AS org_id, course.title, course.slug, course.description, course.logo, course.banner_image, course.cost, course.currency, course.is_published, (select COUNT(*) from lesson as l where l.course_id = course.id) AS total_lessons, (select COUNT(*) from groupmember as gm where gm.group_id = course.group_id AND gm.role_id = 3) as total_students, (select COUNT(*) from lesson_completion as lc join lesson as l on l.id = lc.lesson_id where l.course_id = course.id and lc.is_complete = true and lc.profile_id = profile_id_arg) AS progress_rate, course.type as type, (select groupmember.profile_id from groupmember where groupmember.group_id = "group".id and groupmember.profile_id =  profile_id_arg) as member_profile_id
  from course
  join "group" on "group".id = course.group_id
  join organization on organization.id = "group".organization_id
  where course.status = 'ACTIVE' AND organization.id = org_id_arg
  -- GROUP BY course.id, groupmember.profile_id
  ORDER BY course.created_at DESC;
END;
$function$;
