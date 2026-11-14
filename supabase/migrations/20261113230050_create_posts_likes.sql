create table public.posts (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid not null references public.profiles(id) on delete cascade,
  content text not null default '',
  created_at timestamptz not null default now()
);

create table public.likes (
  post_id uuid not null references public.posts(id) on delete cascade,
  profile_id uuid not null references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (post_id, profile_id)
);

alter table public.posts enable row level security;
alter table public.likes enable row level security;

create policy "posts: leer" on public.posts
for select to authenticated using (true);

create policy "posts: crear los propios" on public.posts
for insert to authenticated with check (profile_id = (select auth.uid()));

create policy "likes: leer" on public.likes
for select to authenticated using (true);

create policy "likes: dar el propio" on public.likes
for insert to authenticated with check (profile_id = (select auth.uid()));

create policy "likes: quitar el propio" on public.likes
for delete to authenticated using (profile_id = (select auth.uid()));

create policy "profiles: leer autores" on public.profiles
for select to authenticated using (true);
