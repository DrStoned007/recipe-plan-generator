-- NutriPlan Database Schema
-- Execute this SQL in your Supabase SQL Editor

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create custom types
CREATE TYPE diet_type AS ENUM ('diabetic', 'renal', 'heart_healthy', 'low_fodmap', 'none');
CREATE TYPE meal_type AS ENUM ('breakfast', 'lunch', 'dinner');

-- Create Users table (extends Supabase auth.users)
CREATE TABLE public.users (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    age INTEGER CHECK (age > 0 AND age < 150),
    diet_type diet_type NOT NULL DEFAULT 'none',
    allergies TEXT[],
    preferences JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create Recipes table
CREATE TABLE public.recipes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    ingredients JSONB NOT NULL DEFAULT '[]',
    instructions JSONB NOT NULL DEFAULT '[]',
    diet_type diet_type NOT NULL DEFAULT 'none',
    nutrition JSONB DEFAULT '{}',
    image_url TEXT,
    prep_time INTEGER, -- in minutes
    cook_time INTEGER, -- in minutes
    servings INTEGER DEFAULT 1,
    created_by UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    is_public BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create Meal_Plans table
CREATE TABLE public.meal_plans (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    recipe_id UUID REFERENCES public.recipes(id) ON DELETE SET NULL,
    date DATE NOT NULL,
    meal_type meal_type NOT NULL,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, date, meal_type)
);

-- Create indexes for better performance
CREATE INDEX idx_users_diet_type ON public.users(diet_type);
CREATE INDEX idx_recipes_diet_type ON public.recipes(diet_type);
CREATE INDEX idx_recipes_created_by ON public.recipes(created_by);
CREATE INDEX idx_recipes_public ON public.recipes(is_public);
CREATE INDEX idx_meal_plans_user_id ON public.meal_plans(user_id);
CREATE INDEX idx_meal_plans_date ON public.meal_plans(date);
CREATE INDEX idx_meal_plans_user_date ON public.meal_plans(user_id, date);

-- Create updated_at triggers
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_users_updated_at 
    BEFORE UPDATE ON public.users 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_recipes_updated_at 
    BEFORE UPDATE ON public.recipes 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_meal_plans_updated_at 
    BEFORE UPDATE ON public.meal_plans 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();