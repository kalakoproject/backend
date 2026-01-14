-- Migration: Add product_units table for managing product units per client
-- Date: 2026-01-13

CREATE TABLE IF NOT EXISTS public.product_units (
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY,
    client_id bigint NOT NULL,
    name character varying(50) NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    PRIMARY KEY (id),
    CONSTRAINT product_units_client_id_fkey FOREIGN KEY (client_id) 
        REFERENCES public.clients (id) ON DELETE CASCADE,
    CONSTRAINT product_units_unique_name_per_client UNIQUE (client_id, name)
);

-- Add some default units for existing clients
INSERT INTO public.product_units (client_id, name)
SELECT DISTINCT c.id, u.name
FROM public.clients c
CROSS JOIN (VALUES ('PCS'), ('KG'), ('Liter'), ('Gram'), ('Box'), ('Dus'), ('Karton')) AS u(name)
WHERE NOT EXISTS (
    SELECT 1 FROM public.product_units pu 
    WHERE pu.client_id = c.id AND pu.name = u.name
)
ON CONFLICT (client_id, name) DO NOTHING;

-- Index for faster lookups
CREATE INDEX IF NOT EXISTS idx_product_units_client_id ON public.product_units (client_id);

COMMENT ON TABLE public.product_units IS 'Stores custom product units per client for retail management';
