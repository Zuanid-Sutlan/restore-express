# Fix PostgreSQL ENUM Type Mismatch

The application currently uses `enumerationByName` in Exposed models, which maps Kotlin enums to `VARCHAR` in the database. However, the PostgreSQL schema uses custom ENUM types (`repair_status`, `product_condition`, `order_status`). PostgreSQL does not automatically cast `VARCHAR` to these custom ENUM types during inserts or updates, leading to `PSQLException`.

## Proposed Changes

### [Component Name] Shared Models & Utilities

#### [MODIFY] [Common.kt](file:///Users/apple/Desktop/Ktor/express/src/main/kotlin/com/restoreexpress/models/Common.kt)
- Add a `PGEnum` class and a `pgEnumeration` helper function to handle PostgreSQL custom ENUM types in Exposed.

### [Component Name] Repair Module

#### [MODIFY] [Repairs.kt](file:///Users/apple/Desktop/Ktor/express/src/main/kotlin/com/restoreexpress/models/Repairs.kt)
- Update `Repairs` and `RepairEvents` tables to use the new `pgEnumeration` helper for the `status` column.

### [Component Name] Shop Module

#### [MODIFY] [Shop.kt](file:///Users/apple/Desktop/Ktor/express/src/main/kotlin/com/restoreexpress/models/Shop.kt)
- Update `Products` table to use `pgEnumeration` for the `condition` column.
- Update `Orders` table to use `pgEnumeration` for the `status` column.

## Verification Plan

### Automated Tests
- Run the application and perform an operation that involves inserting or updating a record with an enum field (e.g., creating a repair or product).
- Since this is a database connectivity issue, it's best verified by running the app against a PostgreSQL instance.

### Manual Verification
- Attempt to start the application and perform a database write operation that previously failed.
- Check the logs to ensure no `PSQLException` is thrown when handling enums.
