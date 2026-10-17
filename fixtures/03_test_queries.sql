-- 03_test_queries.sql
-- Run as a superuser/service role to set up the JWT claim, then inspect results.
-- Replace the UUIDs to match fixtures/00_schema.sql.

-- Simulate Alice (authenticated)
set request.jwt.claim.sub = '11111111-1111-1111-1111-111111111111';
set role authenticated;

select 'ALICE profiles' as scenario;
select id, username from public.profiles;

select 'ALICE posts' as scenario;
select id, author_id, title, published from public.posts;

-- Simulate Bob
set request.jwt.claim.sub = '22222222-2222-2222-2222-222222222222';
select 'BOB profiles' as scenario;
select id, username from public.profiles;

select 'BOB posts' as scenario;
select id, author_id, title, published from public.posts;

-- Reset
reset role;
