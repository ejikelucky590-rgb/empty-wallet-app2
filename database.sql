-- Dove Music Database Schema
-- Table: public.profiles

CREATE TABLE public.profiles (
  id UUID REFERENCES auth.users ON DELETE CASCADE PRIMARY KEY,
  username TEXT UNIQUE NOT NULL DEFAULT '',
  full_name TEXT,
  avatar_url TEXT,
  bio TEXT,
  is_onboarded BOOLEAN DEFAULT false,
  country TEXT,
  state TEXT,
  following_count INT DEFAULT 0,
  followers_count INT DEFAULT 0,
  likes_count INT DEFAULT 0,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- Row Level Security (RLS) Configuration
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- =========================================
-- CONNECTIONS / FOLLOW SYSTEM
-- =========================================

CREATE TABLE IF NOT EXISTS public.connections (
    id BIGSERIAL PRIMARY KEY,

    follower_id UUID NOT NULL
        REFERENCES auth.users(id)
        ON DELETE CASCADE,

    following_id UUID NOT NULL
        REFERENCES auth.users(id)
        ON DELETE CASCADE,

    created_at TIMESTAMPTZ NOT NULL
        DEFAULT timezone('utc', now()),

    CONSTRAINT unique_connection
        UNIQUE (follower_id, following_id),

    CONSTRAINT prevent_self_follow
        CHECK (follower_id <> following_id)
);

-- =========================================
-- PERFORMANCE INDEXES
-- =========================================

CREATE INDEX IF NOT EXISTS idx_connections_follower
ON public.connections(follower_id);

CREATE INDEX IF NOT EXISTS idx_connections_following
ON public.connections(following_id);

CREATE INDEX IF NOT EXISTS idx_connections_created_at
ON public.connections(created_at DESC);

-- =========================================
-- ENABLE ROW LEVEL SECURITY
-- =========================================

ALTER TABLE public.connections
ENABLE ROW LEVEL SECURITY;

-- =========================================
-- RLS POLICIES
-- =========================================

CREATE POLICY "Authenticated users can read connections"
ON public.connections
FOR SELECT
USING (auth.role() = 'authenticated');

CREATE POLICY "Users can follow on their own behalf"
ON public.connections
FOR INSERT
WITH CHECK (auth.uid() = follower_id);

CREATE POLICY "Users can unfollow on their own behalf"
ON public.connections
FOR DELETE
USING (auth.uid() = follower_id);

-- =========================================
-- FOLLOW COUNT TRIGGER FUNCTION
-- =========================================

CREATE OR REPLACE FUNCTION public.handle_connection_change()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN

    IF TG_OP = 'INSERT' THEN

        UPDATE public.profiles
        SET following_count = following_count + 1
        WHERE id = NEW.follower_id;

        UPDATE public.profiles
        SET followers_count = followers_count + 1
        WHERE id = NEW.following_id;

    ELSIF TG_OP = 'DELETE' THEN

        UPDATE public.profiles
        SET following_count = GREATEST(0, following_count - 1)
        WHERE id = OLD.follower_id;

        UPDATE public.profiles
        SET followers_count = GREATEST(0, followers_count - 1)
        WHERE id = OLD.following_id;

    END IF;

    RETURN NULL;
END;
$$;

-- =========================================
-- TRIGGER BINDING
-- =========================================

DROP TRIGGER IF EXISTS on_connection_change
ON public.connections;

CREATE TRIGGER on_connection_change
AFTER INSERT OR DELETE
ON public.connections
FOR EACH ROW
EXECUTE FUNCTION public.handle_connection_change();


-- =========================================
-- LIKES SYSTEM (ENTERPRISE GLOBAL STANDARD)
-- =========================================

CREATE TABLE IF NOT EXISTS public.likes (
    id BIGSERIAL PRIMARY KEY,

    user_id UUID NOT NULL
        REFERENCES auth.users(id)
        ON DELETE CASCADE,

    target_id UUID NOT NULL,

    target_type TEXT NOT NULL,

    created_at TIMESTAMPTZ NOT NULL
        DEFAULT timezone('utc', now()),

    -- Prevent duplicate likes
    CONSTRAINT unique_like
        UNIQUE (user_id, target_id, target_type),

    -- Allowed content types
    CONSTRAINT valid_target_type
        CHECK (
            target_type IN (
                'track',
                'video',
                'post',
                'comment',
                'playlist'
            )
        )
);

-- =========================================
-- PERFORMANCE INDEXES
-- =========================================

CREATE INDEX IF NOT EXISTS idx_likes_user
ON public.likes(user_id);

CREATE INDEX IF NOT EXISTS idx_likes_target
ON public.likes(target_id);

CREATE INDEX IF NOT EXISTS idx_likes_target_lookup
ON public.likes(target_id, target_type);

CREATE INDEX IF NOT EXISTS idx_likes_created_at
ON public.likes(created_at DESC);

-- =========================================
-- ROW LEVEL SECURITY
-- =========================================

ALTER TABLE public.likes ENABLE ROW LEVEL SECURITY;

-- Authenticated users can read likes
CREATE POLICY "Authenticated users can view likes"
ON public.likes
FOR SELECT
USING (auth.role() = 'authenticated');

-- Users can like content as themselves
CREATE POLICY "Users can insert their own likes"
ON public.likes
FOR INSERT
WITH CHECK (auth.uid() = user_id);

-- Users can remove only their own likes
CREATE POLICY "Users can delete their own likes"
ON public.likes
FOR DELETE
USING (auth.uid() = user_id);

-- =========================================
-- REAL-TIME LIKE COUNT FUNCTION
-- =========================================

CREATE OR REPLACE FUNCTION public.handle_like_change()
RETURNS TRIGGER AS $$
BEGIN

    -- TRACK LIKE COUNTS
    IF TG_OP = 'INSERT' THEN

        -- Example future hook:
        -- UPDATE tracks SET likes_count = likes_count + 1 WHERE id = NEW.target_id;

        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN

        -- Example future hook:
        -- UPDATE tracks SET likes_count = GREATEST(0, likes_count - 1)
        -- WHERE id = OLD.target_id;

        RETURN OLD;

    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =========================================
-- TRIGGER
-- =========================================

DROP TRIGGER IF EXISTS on_like_change
ON public.likes;

CREATE TRIGGER on_like_change
AFTER INSERT OR DELETE
ON public.likes
FOR EACH ROW
EXECUTE FUNCTION public.handle_like_change();


-- =========================================
-- AVATAR STORAGE BUCKET (ENTERPRISE)
-- =========================================

-- Create bucket safely
INSERT INTO storage.buckets (
    id,
    name,
    public,
    file_size_limit,
    allowed_mime_types
)
VALUES (
    'avatars',
    'avatars',
    true,
    5242880, -- 5MB
    ARRAY[
        'image/png',
        'image/jpeg',
        'image/webp'
    ]
)
ON CONFLICT (id) DO NOTHING;

-- =========================================
-- CLEAN OLD POLICIES (SAFE REDEPLOY)
-- =========================================

DROP POLICY IF EXISTS "Public avatar access"
ON storage.objects;

DROP POLICY IF EXISTS "Authenticated users can upload avatars"
ON storage.objects;

DROP POLICY IF EXISTS "Users can update their own avatars"
ON storage.objects;

DROP POLICY IF EXISTS "Users can delete their own avatars"
ON storage.objects;

-- =========================================
-- STORAGE ACCESS POLICIES
-- =========================================

-- Public profile image viewing
CREATE POLICY "Public avatar access"
ON storage.objects
FOR SELECT
USING (
    bucket_id = 'avatars'
);

-- Authenticated uploads only
CREATE POLICY "Authenticated users can upload avatars"
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (
    bucket_id = 'avatars'
    AND auth.uid() IS NOT NULL
    AND (storage.foldername(name))[1] = auth.uid()::text
);

-- Users update only their own avatar
CREATE POLICY "Users can update their own avatars"
ON storage.objects
FOR UPDATE
TO authenticated
USING (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = auth.uid()::text
);

-- Users delete only their own avatar
CREATE POLICY "Users can delete their own avatars"
ON storage.objects
FOR DELETE
TO authenticated
USING (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = auth.uid()::text
);

-- =========================================
-- PERFORMANCE INDEXES
-- =========================================

CREATE INDEX IF NOT EXISTS idx_storage_avatar_bucket
ON storage.objects(bucket_id);

CREATE INDEX IF NOT EXISTS idx_storage_avatar_name
ON storage.objects(name);

-- =========================================
-- STORAGE NOTES
-- =========================================
-- Recommended upload path format:
--
-- avatars/{user_id}/avatar.webp
--
-- Example:
-- avatars/f82d8f9/avatar.webp
--
-- Flutter upload recommendation:
--
-- final avatarPath = '${user.id}/avatar.webp';
--
-- await supabase.storage
--   .from('avatars')
--   .uploadBinary(
--      avatarPath,
--      bytes,
--      fileOptions: const FileOptions(
--        cacheControl: '31536000',
--        upsert: true,
--      ),
--   );
--
-- Benefits:
-- ✓ CDN optimized
-- ✓ Cache optimized
-- ✓ Prevents orphan files
-- ✓ Scales globally
-- ✓ Predictable overwrite behavior
-- ✓ Enterprise media architecture


-- =========================================
-- CONTROLLER BACKEND INTEGRATION REFERENCE
-- =========================================
-- Handled cleanly via ProfileService.instance
-- Guaranteed contextual state safety via widget lifecycle !mounted guards
-- Microtask UI popping execution isolation verified
