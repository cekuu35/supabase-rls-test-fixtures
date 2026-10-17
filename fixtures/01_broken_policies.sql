-- 01_broken_policies.sql
-- INTENTIONALLY INSECURE policies. Demonstrates common RLS mistakes.
-- Run only in a throwaway database.

-- Reset any existing policies on the tables.
drop policy if exists "profiles_select_all" on public.profiles;
drop policy if exists "profiles_update_own" on public.profiles;
drop policy if exists "posts_select_all" on public.posts;
drop policy if exists "posts_insert_own" on public.posts;
drop policy if exists "posts_update_own" on public.posts;
drop policy if exists "posts_delete_own" on public.posts;

-- BROKEN 1: any authenticated user can read every profile.
create policy "profiles_select_all"
  on public.profiles for select
  to authenticated
  using (true);

-- BROKEN 2: update has USING but no WITH CHECK -> can move rows to other users.
create policy "profiles_update_own"
  on public.profiles for update
  to authenticated
  using (id = auth.uid());

-- BROKEN 3: published filter forgotten -> drafts leak to everyone.
create policy "posts_select_all"
  on public.posts for select
  to authenticated
  using (true);

-- BROKEN 4: insert missing WITH CHECK -> can impersonate another author.
create policy "posts_insert_own"
  on public.posts for insert
  to authenticated
  with check (true);

-- BROKEN 5: update allows changing author_id (no WITH CHECK).
create policy "posts_update_own"
  on public.posts for update
  to authenticated
  using (author_id = auth.uid());

-- BROKEN 6: delete policy too broad.
create policy "posts_delete_own"
  on public.posts for delete
  to authenticated
  using (true);
