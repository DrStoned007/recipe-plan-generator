-- Row Level Security (RLS) Policies
-- Execute this SQL in your Supabase SQL Editor AFTER creating the schema

-- Enable RLS on all tables
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.recipes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.meal_plans ENABLE ROW LEVEL SECURITY;

-- Users table policies
CREATE POLICY "Users can view their own profile" ON public.users
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile" ON public.users
    FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert their own profile" ON public.users
    FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can delete their own profile" ON public.users
    FOR DELETE USING (auth.uid() = id);

-- Recipes table policies
CREATE POLICY "Users can view public recipes" ON public.recipes
    FOR SELECT USING (is_public = true);

CREATE POLICY "Users can view their own recipes" ON public.recipes
    FOR SELECT USING (auth.uid() = created_by);

CREATE POLICY "Users can insert their own recipes" ON public.recipes
    FOR INSERT WITH CHECK (auth.uid() = created_by);

CREATE POLICY "Users can update their own recipes" ON public.recipes
    FOR UPDATE USING (auth.uid() = created_by);

CREATE POLICY "Users can delete their own recipes" ON public.recipes
    FOR DELETE USING (auth.uid() = created_by);

-- Meal_Plans table policies
CREATE POLICY "Users can view their own meal plans" ON public.meal_plans
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own meal plans" ON public.meal_plans
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own meal plans" ON public.meal_plans
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own meal plans" ON public.meal_plans
    FOR DELETE USING (auth.uid() = user_id);