# Restore Express Server

A clean, layered Ktor server for a repair service and refurbished device shop.

## Tech Stack
- **Ktor** (Core, Sessions, FreeMarker, ContentNegotiation)
- **Exposed ORM** + **PostgreSQL**
- **Flyway** (Migrations)
- **Stripe Java SDK** (Payments)
- **Kotlinx Serialization** (JSON)
- **FreeMarker** (HTML Templates)
- **dotenv-kotlin** (Configuration)

## Project Structure
- `config/`: Infrastructure setup (DB, Stripe, Auth)
- `models/`: Database tables (Exposed) and Data Classes
- `services/`: Business logic (Repair, Shop, Stripe)
- `routes/`: Ktor route handlers grouped by feature
- `templates/`: FreeMarker `.ftl` files (as requested in `src/main/kotlin/...`)
- `resources/db/migration/`: Flyway SQL scripts

## Setup

1. **Environment Variables**:
   Copy `.env.example` to `.env` and fill in your Stripe keys and database credentials.
   ```bash
   cp .env.example .env
   ```

2. **Database**:
   Run the local PostgreSQL instance using Docker:
   ```bash
   docker-compose up -d
   ```

3. **Run Migrations**:
   Flyway migrations run automatically on application startup via `DatabaseFactory`.

4. **Run the Application**:
   ```bash
   ./gradlew run
   ```
   The server will be available at `http://localhost:8080`.

## Key Routes
- `/`: Homepage
- `/repair/book`: Repair booking form
- `/shop`: Product catalog
- `/track`: Tracking page (lookup by reference)
- `/admin/login`: Admin gateway
- `/webhooks/stripe`: Stripe payment verification

## Database Schema
The schema is defined in `V1__init.sql` and mapped in `models/*.kt`. 
It includes modules for:
- **Repairs**: Tracking status, customer details, and payments.
- **Shop**: Inventory management, orders, and items.
- **Admins**: Secure access to the dashboard.
