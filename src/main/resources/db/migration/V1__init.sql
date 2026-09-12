-- Types
CREATE TYPE repair_status AS ENUM ('RECEIVED', 'REPAIRING', 'WAITING_FOR_APPROVAL', 'REPAIRED', 'DISPATCHED');
CREATE TYPE product_condition AS ENUM ('NEW', 'REFURBISHED_A', 'REFURBISHED_B', 'USED');
CREATE TYPE order_status AS ENUM ('PENDING', 'PAID', 'PROCESSING', 'SHIPPED', 'DELIVERED', 'CANCELLED', 'REFUNDED');

-- REPAIR MODULE
CREATE TABLE repairs (
    id SERIAL PRIMARY KEY,
    reference_code VARCHAR(50) UNIQUE NOT NULL,
    customer_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(50) NOT NULL,
    device_model VARCHAR(255) NOT NULL,
    imei_serial VARCHAR(100),
    reported_fault TEXT NOT NULL,
    condition_notes TEXT,
    status repair_status DEFAULT 'RECEIVED' NOT NULL,
    quoted_price_pence INT NOT NULL,
    deposit_paid_pence INT DEFAULT 0 NOT NULL,
    balance_due_pence INT NOT NULL,
    stripe_payment_intent_id VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE repair_events (
    id SERIAL PRIMARY KEY,
    repair_id INT REFERENCES repairs(id) ON DELETE CASCADE NOT NULL,
    status repair_status NOT NULL,
    note TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE repair_photos (
    id SERIAL PRIMARY KEY,
    repair_id INT REFERENCES repairs(id) ON DELETE CASCADE NOT NULL,
    url TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- SHOP MODULE
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    brand VARCHAR(100) NOT NULL,
    model_name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    condition product_condition NOT NULL,
    storage_variant VARCHAR(50),
    color VARCHAR(50),
    price_pence INT NOT NULL,
    stock_quantity INT DEFAULT 0 NOT NULL,
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE product_images (
    id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(id) ON DELETE CASCADE NOT NULL,
    url TEXT NOT NULL,
    sort_order INT DEFAULT 0 NOT NULL
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    order_reference VARCHAR(50) UNIQUE NOT NULL,
    customer_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(50) NOT NULL,
    shipping_address_line1 TEXT NOT NULL,
    shipping_address_line2 TEXT,
    shipping_city VARCHAR(100) NOT NULL,
    shipping_postcode VARCHAR(20) NOT NULL,
    shipping_country VARCHAR(100) NOT NULL,
    status order_status DEFAULT 'PENDING' NOT NULL,
    subtotal_pence INT NOT NULL,
    shipping_cost_pence INT NOT NULL,
    total_pence INT NOT NULL,
    stripe_payment_intent_id VARCHAR(255),
    tracking_number VARCHAR(100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(id) ON DELETE CASCADE NOT NULL,
    product_id INT REFERENCES products(id) NOT NULL,
    quantity INT NOT NULL,
    unit_price_pence INT NOT NULL
);

-- SHARED
CREATE TABLE admins (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);
