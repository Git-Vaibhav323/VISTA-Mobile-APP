-- Location: supabase/migrations/20250828170228_update_user_schema_email_auth.sql
-- Schema Analysis: Existing user table with phone number, updating to email auth
-- Integration Type: modification/enhancement
-- Dependencies: user, orders, products, order_items tables

-- Step 1: Add email column to existing user table and update schema for email authentication
ALTER TABLE public."user" 
ADD COLUMN IF NOT EXISTS email TEXT;

-- Create unique index for email
CREATE UNIQUE INDEX IF NOT EXISTS user_email_key ON public."user"(email);

-- Remove unique constraint on phone number to make it optional
DROP INDEX IF EXISTS "user_phone number_key";

-- Create user_profiles table as intermediary for Supabase auth integration
CREATE TABLE IF NOT EXISTS public.user_profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL UNIQUE,
    full_name TEXT,
    business_name TEXT,
    role TEXT NOT NULL DEFAULT 'vendor',
    city TEXT,
    phone_number TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Add indexes for performance
CREATE INDEX IF NOT EXISTS idx_user_profiles_email ON public.user_profiles(email);
CREATE INDEX IF NOT EXISTS idx_user_profiles_role ON public.user_profiles(role);

-- Update existing tables to reference user_profiles instead of user table where needed
-- Add foreign key constraints for proper relationships

-- Enable RLS on user_profiles
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;

-- RLS Policy for user_profiles - Pattern 1 (Core User Table)
CREATE POLICY "users_manage_own_user_profiles"
ON public.user_profiles
FOR ALL
TO authenticated
USING (id = auth.uid())
WITH CHECK (id = auth.uid());

-- Enable RLS on existing tables
ALTER TABLE public."user" ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.order_items ENABLE ROW LEVEL SECURITY;

-- RLS Policies for existing tables - Pattern 2 (Simple User Ownership)
CREATE POLICY "users_manage_own_user_data"
ON public."user"
FOR ALL
TO authenticated
USING (id = auth.uid())
WITH CHECK (id = auth.uid());

CREATE POLICY "users_manage_own_orders"
ON public.orders
FOR ALL
TO authenticated
USING (vendor_id = auth.uid())
WITH CHECK (vendor_id = auth.uid());

CREATE POLICY "users_manage_own_products"
ON public.products
FOR ALL
TO authenticated
USING (supplier_id = auth.uid())
WITH CHECK (supplier_id = auth.uid());

CREATE POLICY "users_can_access_order_items"
ON public.order_items
FOR ALL
TO authenticated
USING (true);

-- Function to handle new user creation
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO public.user_profiles (id, email, full_name, role)
  VALUES (
    NEW.id, 
    NEW.email, 
    COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1)),
    COALESCE(NEW.raw_user_meta_data->>'role', 'vendor')::TEXT
  );  
  RETURN NEW;
END;
$$;

-- Trigger for new user creation
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Mock data with complete auth.users records for email authentication
DO $$
DECLARE
    vendor_uuid UUID := gen_random_uuid();
    supplier_uuid UUID := gen_random_uuid();
    product_uuid UUID := gen_random_uuid();
    order_uuid UUID := gen_random_uuid();
BEGIN
    -- Create auth users with email authentication
    INSERT INTO auth.users (
        id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
        created_at, updated_at, raw_user_meta_data, raw_app_meta_data,
        is_sso_user, is_anonymous, confirmation_token, confirmation_sent_at,
        recovery_token, recovery_sent_at, email_change_token_new, email_change,
        email_change_sent_at, email_change_token_current, email_change_confirm_status,
        reauthentication_token, reauthentication_sent_at, phone, phone_change,
        phone_change_token, phone_change_sent_at
    ) VALUES
        (vendor_uuid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'vendor@vista.com', crypt('password123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Street Food Vendor"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null),
        (supplier_uuid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'supplier@vista.com', crypt('password123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Food Supplier"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null);

    -- Insert into existing user table (legacy compatibility)
    INSERT INTO public."user" (id, "business name", city, role, "phone number", email) VALUES
        (vendor_uuid, 'Street Food Corner', 'Mumbai', 'vendor', '9876543210', 'vendor@vista.com'),
        (supplier_uuid, 'Fresh Ingredients Ltd', 'Delhi', 'supplier', '9876543211', 'supplier@vista.com');

    -- Create business data
    INSERT INTO public.products (id, name, price, stock, supplier_id, "expiry date") VALUES
        (product_uuid, 'Fresh Vegetables', 50.00, 100, supplier_uuid, '2025-12-31');

    INSERT INTO public.orders (id, vendor_id, status, total_price) VALUES
        (order_uuid, vendor_uuid, 'pending', 150.00);

    INSERT INTO public.order_items (id, order_id, product_id, quantity, price) VALUES
        (gen_random_uuid(), order_uuid, product_uuid, 3, 50.00);
END $$;