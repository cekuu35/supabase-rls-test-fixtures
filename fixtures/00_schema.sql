-- 00_schema.sql
-- Sample schema used by the RLS test fixtures.
-- Safe to run in a fresh Supabase project or local Postgres with the auth schema.

create extension if not exists "uuid-ossp";

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username text unique not null,
  display_name text,
  created_at timestamptz default now()
);

create table if not exists public.posts (
  id uuid primary key default uuid_generate_v4(),
  author_id uuid not null references public.profiles(id) on delete cascade,
  title text not null,
  body text,
  published boolean default false,
  created_at timestamptz default now()
);

-- Enable RLS on both tables. Without this, policies are inert.
alter table public.profiles enable row level security;
alter table public.posts enable row level security;

-- Seed two users (replace UUIDs with real auth.users ids in your project).
insert into public.profiles (id, username, display_name) values
  ('11111111-1111-1111-1111-111111111111', 'alice', 'Alice'),
  ('22222222-2222-2222-2222-222222222222', 'bob', 'Bob')
on conflict (id) do nothing;

insert into public.posts (author_id, title, body, published) values
  ('11111111-1111-1111-1111-111111111111', 'Alice draft', 'private', false),
  ('11111111-1111-1111-1111-111111111111', 'Alice public', 'hello world', true),
  ('22222222-2222-2222-2222-222222222222', 'Bob draft', 'secret', false)
on conflict do nothing;
