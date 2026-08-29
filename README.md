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

## Branch Strategy & CI / PR Pipeline

### Branch Flow
```text
[ feature/* or fix/* ] --(PR + CI)--> [ develop ] --(PR + CI)--> [ main (Production) ]
```
1. **Feature / Fix Branches**: Create your working branch from `develop`.
2. **PR to `develop`**: Open a PR targeting `develop`. GitHub Actions automatically verifies and tests the code.
3. **PR to `main`**: When `develop` is ready for production release, open a PR from `develop` to `main`. GitHub Actions runs verification again before merge.

### Workflow Jobs (`.github/workflows/ci.yml`):
1. **Validate Gradle Wrapper**: Verifies wrapper integrity against official checksums.
2. **Build & Test**: Sets up JDK 21, builds the project with `./gradlew assemble`, executes all tests via `./gradlew check`, and uploads HTML test reports as artifacts.

### Required GitHub Branch Protection Setup:
To enforce PR verification before merging:
1. Go to your GitHub repository **Settings** > **Branches**.
2. Add branch protection rules for both **`develop`** and **`main`**.
3. Enable **Require a pull request before merging**.
4. Enable **Require status checks to pass before merging**.
5. Select **`Build & Test`** and **`Validate Gradle Wrapper`** as required status checks.

## Database Schema
The schema is defined in `V1__init.sql` and mapped in `models/*.kt`. 
It includes modules for:
- **Repairs**: Tracking status, customer details, and payments.
- **Shop**: Inventory management, orders, and items.
- **Admins**: Secure access to the dashboard.
